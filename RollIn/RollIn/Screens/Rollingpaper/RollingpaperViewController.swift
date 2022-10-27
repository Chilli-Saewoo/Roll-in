//
//  RollingpaperViewController.swift
//  RollIn
//
//  Created by 한택환 on 2022/10/22.
//

import UIKit
import Firebase

final class RollingpaperViewController: UIViewController {
    
    private let rollingpaperView = RollingpaperView()
    private let titleText = UILabel()
    private let qrButton = UIButton(type: .custom)
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
        titleText.text = "\(UserDefaults.nickname ?? "")님의 롤링페이퍼"
        titleText.font = .systemFont(ofSize: 20, weight: .semibold)
        titleText.textColor = UIColor(hex: "FFF6F2")
        setQRButton()
        observeUserNotes()
        setNotesInRollingpaperView()
        rollingpaperView.delegate = self
        view.backgroundColor = .CustomBackgroundColor
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
            
            let randomSize = CGFloat.random(in:(CGFloat(100 / notesSizePropotion) ... CGFloat(Int(100 / notesSizePropotion) + Int(20 / notesSizePropotion))))
            let centerXStart = (randomSize / 2)
            let centerXEnd = viewWidth - (randomSize / 2)
            let centerYStart = 112 + (randomSize / 2)
            let centerYEnd = viewHeight - (randomSize / 2)
            let rectPosition = CGPoint(x: CGFloat.random(in: centerXStart...centerXEnd),
                                       y: CGFloat.random(in: centerYStart...centerYEnd))
            let rectSize = CGSize(width: randomSize, height: randomSize)
            let noteView = NoteView(frame: CGRect(origin: .zero, size: rectSize), note: note, noteSizeProportion: notesSizePropotion)
            noteView.center = rectPosition
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
        view.addSubview(titleText)
        titleText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleText.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            titleText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setQRButton() {
        view.addSubview(qrButton)
        qrButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            qrButton.widthAnchor.constraint(equalToConstant: 24),
            qrButton.heightAnchor.constraint(equalToConstant: 24),
            qrButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            qrButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        let qrImage = UIImage(systemName: "qrcode")
        qrButton.setImage(qrImage, for: .normal)
        qrButton.imageView?.tintColor = UIColor(hex: "FFF6F2")
        qrButton.addTarget(self, action: #selector(qrButtonPressed), for: .touchUpInside)
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
