//
//  RollingpaperViewController.swift
//  RollIn
//
//  Created by 한택환 on 2022/10/22.
//

import UIKit
import Firebase


struct NoteConfig: Codable {
    var isPlaced: Bool
    var centerX: Float
    var centerY: Float
    var rotation: Float
    var size: Float
}

final class RollingpaperViewController: UIViewController {
    
    private let rollingpaperView = RollingpaperView()
    private var topBackgroundView = UIView()
    private let titleText = UILabel()
    private let buttonBackgroundView = UIButton(type: .custom)
    private let qrImageView = UIImageView()
    private let ref = Database.database().reference()
    private let viewWidth: CGFloat = UIScreen.main.bounds.width
    private let viewHeight: CGFloat = UIScreen.main.bounds.height
    private var notesSizePropotion: CGFloat = 1
    
    var notes: [Note] = [] {
        didSet {
            let noteViews = rollingpaperView.subviews.filter { $0 is NoteView }
            for noteView in noteViews {
                noteView.removeFromSuperview()
            }
            setNotesInRollingpaperView()
            rollingpaperView.noteSizeProportion = notesSizePropotion
        }
    }
    
    var recievedNotes: [String : [String : AnyObject]] = [:] {
        didSet {
            var newNotes: [Note] = []
            for recievedNote in recievedNotes {
                let addedDateString = recievedNote.value["timestamp"] as? String ?? ""
                let formatter = DateFormatter()
                formatter.dateFormat = "E, d MMM yyyy HH:mm:ss zzz"
                formatter.timeZone = TimeZone(identifier: "UTC")
                let dateObject = formatter.date(from: addedDateString) ?? Date()
                let newNote = Note(id: recievedNote.key,
                                   timeStamp: dateObject,
                                   sender: recievedNote.value["sender"] as? String ?? "",
                                   image: recievedNote.value["image"] as? Int ?? 0,
                                   message: recievedNote.value["message"] as? String ?? "")
                newNotes.append(newNote)
            }
            self.notes = newNotes.sorted(by: <)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        setRollingpaperView()
        setTitleTextLabel()
        topBackgroundView.backgroundColor = .CustomBackgroundColor
        topBackgroundView.layer.opacity = 0.9
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        topBackgroundView = UIVisualEffectView(effect: blurEffect)
        titleText.text = "\(UserDefaults.nickname ?? "")님의 롤링페이퍼"
        titleText.font = .systemFont(ofSize: 20, weight: .semibold)
        titleText.textColor = UIColor(hex: "FFF6F2")
        setQRButton()
        observeUserNotes()
        setNotesInRollingpaperView()
        rollingpaperView.delegate = self
        view.backgroundColor = .CustomBackgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setNotesInRollingpaperView() {
        let notesCount = notes.count
        
        switch notesCount {
        case 0 ... 5:
            notesSizePropotion = 1
        case 6 ... 15:
            notesSizePropotion = 1.6
        case 16 ... 35:
            notesSizePropotion = 2.5
        case 36 ... 63:
            notesSizePropotion = 3.5
        case 64 ... 99:
            notesSizePropotion = 4.5
        default:
            notesSizePropotion = 5
        }
        
        for note in notes {
            let noteView = NoteView(frame: CGRect(origin: .zero, size: .zero), note: note, noteSizeProportion: notesSizePropotion)
            let key = note.id
            var newNoteConfig: NoteConfig? = nil
            
            if let noteConfig = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let savedObject = try? decoder.decode(NoteConfig.self, from: noteConfig) {
                    newNoteConfig = savedObject
                }
            }
            
            if newNoteConfig == nil {
                var isPlaceable = false
                let rawRandomSize = CGFloat.random(in: 100 ... 140)
                let randomSize = rawRandomSize / notesSizePropotion
                let rectSize = CGSize(width: randomSize, height: randomSize)
                
                noteView.frame.size = rectSize
                let rectRotation: Double = Double.random(in: -30 ..< 30)
                noteView.transform = CGAffineTransformMakeRotation(rectRotation * Double.pi / 180)
                let centerXStart = (randomSize / 2)
                let centerXEnd = viewWidth - (randomSize / 2)
                let centerYStart = 112 + (randomSize / 2)
                let centerYEnd = viewHeight - (randomSize / 2)
                while !isPlaceable {
                    let rectPosition = CGPoint(x: CGFloat.random(in: centerXStart...centerXEnd),
                                               y: CGFloat.random(in: centerYStart...centerYEnd))
                    noteView.center = rectPosition
                    // MARK: - 겹치는지 조사하는 함수! 안겹치면 넣어준다.
                    for existedNoteView in rollingpaperView.subviews.filter({ $0 is NoteView }) {
                        if existedNoteView.frame.intersects(noteView.frame) {
                            isPlaceable = false
                            break
                        } else {
                            isPlaceable = true
                        }
                    }
                    if rollingpaperView.subviews.filter({ $0 is NoteView }).count == 0 {
                        isPlaceable = true
                    }
                    
                    let newConfig = NoteConfig(isPlaced: true,
                                               centerX: Float(noteView.center.x),
                                               centerY: Float(noteView.center.y),
                                               rotation: Float(rectRotation),
                                               size: Float(rawRandomSize))
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(newConfig) {
                        UserDefaults.standard.setValue(encoded, forKey: key)
                    }
                    
                }
            } else {
                noteView.frame.size = CGSize(width: CGFloat(newNoteConfig?.size ?? 0) / notesSizePropotion,
                                             height: CGFloat(newNoteConfig?.size ?? 0) / notesSizePropotion)
                noteView.transform = CGAffineTransformMakeRotation(Double((newNoteConfig?.rotation ?? 0)) * Double.pi / 180)
                noteView.center = CGPoint(x: CGFloat(newNoteConfig?.centerX ?? 0),
                                          y: CGFloat(newNoteConfig?.centerY ?? 0))
            }
            rollingpaperView.addSubview(noteView)
        }
        
    }
    
    
    private func observeUserNotes() {
        guard let userId = UserDefaults.userId else { return }
        self.ref.child("users").child(userId).child("notes").observe(.value) { snapshot in
            self.recievedNotes = snapshot.value as? [String : [String : AnyObject]] ?? [:]
        }
    }
    
    @objc func qrButtonPressed(_ sender: UIButton) {
        print("touched")
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "QRShowingVC") ?? UIViewController()
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
}

extension RollingpaperViewController: RollingpaperViewDelegate {
    func handleOpacityValue(newVal: Float) {
        let noteViews = rollingpaperView.subviews.filter { $0 is NoteView }
        for noteView in noteViews {
            (noteView as? NoteView)?.foregroundImageOpacity = newVal
        }
    }
}

private extension RollingpaperViewController {
    func setTitleTextLabel() {
        view.addSubview(topBackgroundView)
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            topBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBackgroundView.heightAnchor.constraint(equalToConstant: 112)
        ])
        view.addSubview(titleText)
        titleText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleText.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            titleText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setQRButton() {
        view.addSubview(qrImageView)
        qrImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            qrImageView.widthAnchor.constraint(equalToConstant: 24),
            qrImageView.heightAnchor.constraint(equalToConstant: 24),
            qrImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            qrImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        let qrImage = UIImage(systemName: "qrcode")
        qrImageView.image = qrImage
        qrImageView.tintColor = UIColor(hex: "FFF6F2")
        
        view.addSubview(buttonBackgroundView)
        buttonBackgroundView.frame.size = CGSize(width: 50, height: 50)
        buttonBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonBackgroundView.widthAnchor.constraint(equalToConstant: 50),
            buttonBackgroundView.heightAnchor.constraint(equalToConstant: 50),
            buttonBackgroundView.centerXAnchor.constraint(equalTo: qrImageView.centerXAnchor),
            buttonBackgroundView.centerYAnchor.constraint(equalTo: qrImageView.centerYAnchor),
        ])
        buttonBackgroundView.addTarget(self, action: #selector(qrButtonPressed), for: .touchUpInside)
        view.bringSubviewToFront(buttonBackgroundView)
        
    }
}

private extension RollingpaperViewController {
    func setRollingpaperView() {
        view.addSubview(rollingpaperView)
        rollingpaperView.frame = view.frame
    }
}

// MARK: - Preview
#if DEBUG
import SwiftUI
struct RollingpaperVCPreview: PreviewProvider {
    static var previews: some View {
        RollingpaperViewController().toPreview()
    }
}
#endif
