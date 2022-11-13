//
//  ParticipateGroupConfirmCardView.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/13.
//

import UIKit

final class ParticipateGroupConfirmCardView: UIView {

    private let iconView = UILabel()
    private let groupNameLabel = UILabel()
    private let createdDateLabel = UILabel()
    let participateCountLabel = UILabel()
    
    init(info: ParticipateGroupInfo) {
        super.init(frame: .zero)
        setIcon()
        setGroupNameLabel()
        setCreatedDateLabel()
        setParticipateCountLabel()
        self.layer.cornerRadius = 8.0
        self.backgroundColor = hexStringToUIColor(hex: info.groupTheme ?? "")
        setIconContents(data: info.groupIcon ?? "")
        groupNameLabel.text = info.groupName ?? ""
        createdDateLabel.text = info.timeStamp?.toString_ConfirmCreatingGroup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setParticipateCountLabel() {
        self.addSubview(participateCountLabel)
        participateCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            participateCountLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            participateCountLabel.topAnchor.constraint(equalTo: createdDateLabel.bottomAnchor, constant: 4),
        ])
        participateCountLabel.font = .systemFont(ofSize: 12, weight: .regular)
        participateCountLabel.textColor = .systemBlack
    }
    
    private func setIconContents(data: String) {
        switch data {
        case "school":
            iconView.text = "🏫"
        case "tree":
            iconView.text = "🎄"
        case "congratulate":
            iconView.text = "🎉"
        case "smile":
            iconView.text = "😀"
        case "heart":
            iconView.text = "❤️"
        default:
            iconView.text = "❤️"
        }
    }
    
    private func setIcon() {
        self.addSubview(iconView)
        self.clipsToBounds = true
        self.clipsToBounds = true
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 2.0),
            iconView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 2.0),
        ])
        NSLayoutConstraint(item: iconView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.75, constant: 0).isActive = true
        iconView.textAlignment = .center
        iconView.font = .systemFont(ofSize: 200)
        iconView.adjustsFontSizeToFitWidth = true
        iconView.minimumScaleFactor = 0.5
        iconView.numberOfLines = 0
        iconView.layer.opacity = 0.4
        iconView.backgroundColor = .clear
    }
    
    private func setGroupNameLabel() {
        self.addSubview(groupNameLabel)
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 17),
            groupNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 17),
        ])
        groupNameLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        groupNameLabel.textAlignment = .left
        groupNameLabel.textColor = .systemBlack
    }
    
    private func setCreatedDateLabel() {
        self.addSubview(createdDateLabel)
        createdDateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createdDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            createdDateLabel.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor, constant: 12),
        ])
        createdDateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        createdDateLabel.textAlignment = .left
        createdDateLabel.textColor = .systemBlack
        createdDateLabel.layer.opacity = 0.75
    }
}
