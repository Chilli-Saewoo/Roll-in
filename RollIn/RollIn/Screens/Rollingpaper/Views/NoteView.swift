//
//  NoteView.swift
//  RollIn
//
//  Created by Noah Park on 2022/10/26.
//

import UIKit

final class NoteView: UIView {
    private let note: Note
    private let backgroundImage = UIImageView()
    private let messageTxt = UILabel()
    private let senderText = UILabel()
    private let foregroundImage = UIImageView()
    
    
    init(frame: CGRect, note: Note) {
        self.note = note
        super.init(frame: frame)
        self.addSubview(backgroundImage)
        self.addSubview(messageTxt)
        self.addSubview(senderText)
        self.addSubview(foregroundImage)
        setNoteViewLayout()
        setImages()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setImages() {
        backgroundImage.image = UIImage(named: "batOrange")
        foregroundImage.image = UIImage(named: "batOrange")
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
        foregroundImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            foregroundImage.topAnchor.constraint(equalTo: self.topAnchor),
            foregroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            foregroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            foregroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
}
