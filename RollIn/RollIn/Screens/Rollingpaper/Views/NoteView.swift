//
//  NoteView.swift
//  RollIn
//
//  Created by Noah Park on 2022/10/26.
//

import UIKit

final class NoteView: UIView {
    private var note: Note
    private let backgroundImage = UIImageView()
    private let messageText = UITextView()
    private let senderText = UILabel()
    private let fromText = UILabel()
    private let foregroundImage = UIImageView()
    var foregroundImageOpacity: Float = 1.0 {
        didSet {
            foregroundImage.layer.opacity = foregroundImageOpacity
        }
    }
    var noteSizeProportion: CGFloat
    
    
    init(frame: CGRect, note: Note, noteSizeProportion: CGFloat) {
        self.note = note
        self.noteSizeProportion = noteSizeProportion
        super.init(frame: frame)
        self.addSubview(backgroundImage)
        self.addSubview(messageText)
        self.addSubview(senderText)
        self.addSubview(fromText)
        self.addSubview(foregroundImage)
        setNoteViewLayout()
        setImagesAndContentsLayout(imageId: note.image)
        setNoteContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNoteContents() {
        messageText.text = note.message
        messageText.font = .systemFont(ofSize: CGFloat(5/noteSizeProportion), weight: .regular)
        messageText.textAlignment = .left
        messageText.backgroundColor = .clear
        messageText.isEditable = false
        let padding = messageText.textContainer.lineFragmentPadding
        messageText.textContainerInset =  UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        senderText.text = note.sender
        senderText.font = .systemFont(ofSize: CGFloat(5/noteSizeProportion), weight: .regular)
        senderText.textAlignment = .right
        fromText.text = "From. "
        fromText.font = .systemFont(ofSize: CGFloat(5/noteSizeProportion), weight: .bold)
        fromText.textAlignment = .right
    }
    
    private func setImagesAndContentsLayout(imageId: Int) {
        switch imageId {
        case 1:
            backgroundImage.image = UIImage(named: "pumpkinOrangeBackground")
            foregroundImage.image = UIImage(named: "pumpkinOrange")
            setTextLayout(width: 0.64, height: 0.5, centerX: -0.04, centerY: 0.15)
        case 2:
            backgroundImage.image = UIImage(named: "pumpkinPurpleBackground")
            foregroundImage.image = UIImage(named: "pumpkinPurple")
            setTextLayout(width: 0.64, height: 0.5, centerX: -0.04, centerY: 0.15)
        case 3:
            backgroundImage.image = UIImage(named: "batOrangeBackground")
            foregroundImage.image = UIImage(named: "batOrange")
            setTextLayout(width: 0.65, height: 0.5, centerX: 0, centerY: -0.15)
        case 4:
            backgroundImage.image = UIImage(named: "batPurpleBackground")
            foregroundImage.image = UIImage(named: "batPurple")
            setTextLayout(width: 0.65, height: 0.5, centerX: 0, centerY: -0.15)
        case 5:
            backgroundImage.image = UIImage(named: "carriageOrangeBackground")
            foregroundImage.image = UIImage(named: "carriageOrange")
            setTextLayout(width: 0.6, height: 0.5, centerX: 0, centerY: 0.2)
        case 6:
            backgroundImage.image = UIImage(named: "carriagePurpleBackground")
            foregroundImage.image = UIImage(named: "carriagePurple")
            setTextLayout(width: 0.6, height: 0.5, centerX: 0, centerY: 0.2)
        case 7:
            backgroundImage.image = UIImage(named: "ghostOrangeBackground")
            foregroundImage.image = UIImage(named: "ghostOrange")
            setTextLayout(width: 0.7, height: 0.5, centerX: 0, centerY: 0.18)
        case 8:
            backgroundImage.image = UIImage(named: "ghostPurpleBackground")
            foregroundImage.image = UIImage(named: "ghostPurple")
            setTextLayout(width: 0.7, height: 0.5, centerX: 0, centerY: 0.18)
        case 9:
            backgroundImage.image = UIImage(named: "skullOrangeBackground")
            foregroundImage.image = UIImage(named: "skullOrange")
            setTextLayout(width: 0.77, height: 0.45, centerX: 0, centerY: -0.35)
        case 10:
            backgroundImage.image = UIImage(named: "skullPurpleBackground")
            foregroundImage.image = UIImage(named: "skullPurple")
            setTextLayout(width: 0.77, height: 0.45, centerX: 0, centerY: -0.35)
        default:
            backgroundImage.image = UIImage(named: "skullPurpleBackground")
            foregroundImage.image = UIImage(named: "skullPurple")
            setTextLayout(width: 0.77, height: 0.4, centerX: 0, centerY: -0.35)
        }
        
        senderText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            senderText.trailingAnchor.constraint(equalTo: messageText.trailingAnchor),
            senderText.topAnchor.constraint(equalTo: messageText.bottomAnchor)
        ])
        
        fromText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fromText.trailingAnchor.constraint(equalTo: senderText.leadingAnchor),
            fromText.topAnchor.constraint(equalTo: messageText.bottomAnchor)
        ])
    }
    
    private func setTextLayout(width: CGFloat, height: CGFloat, centerX: CGFloat, centerY: CGFloat) {
        messageText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageText.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: width),
            messageText.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: height),
            messageText.centerXAnchor.anchorWithOffset(to: self.centerXAnchor).constraint(equalTo: messageText.widthAnchor, multiplier: centerX),
            messageText.centerYAnchor.anchorWithOffset(to: self.centerYAnchor).constraint(equalTo: messageText.heightAnchor, multiplier: centerY)
        ])
    }
    
    private func setNoteViewLayout() {
        self.backgroundColor = .clear
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        backgroundImage.contentMode = .scaleAspectFit
        
        foregroundImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            foregroundImage.topAnchor.constraint(equalTo: self.topAnchor),
            foregroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            foregroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            foregroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        foregroundImage.contentMode = .scaleAspectFit
    }
    
}
