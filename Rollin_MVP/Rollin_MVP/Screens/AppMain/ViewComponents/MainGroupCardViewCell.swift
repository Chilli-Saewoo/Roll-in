//
//  MainGroupCardViewCell.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/14.
//

import UIKit

final class MainGroupCardViewCell: UICollectionViewCell {
    private let iconView = UILabel()
    private let groupNameLabel = UILabel()
    private let createdDateLabel = UILabel()
    private let participateCountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setIcon()
        setGroupNameLabel()
        setCreatedDateLabel()
        setParticipateCountLabel()
        self.layer.cornerRadius = 8.0
    }
    
    public func setCardView(info: Group) {
        self.backgroundColor = hexStringToUIColor(hex: info.groupTheme)
        setIconContents(data: info.groupIcon)
        groupNameLabel.text = info.groupName
        createdDateLabel.text = info.timestamp.toString_ConfirmCreatingGroup()
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "person.fill")?.withTintColor(.systemBlack)
        imageAttachment.setImageHeight(height: 10)
        let fullString = NSMutableAttributedString(attachment: imageAttachment)
        fullString.append(NSMutableAttributedString(string: " \(info.participants.count)명 참여중"))
        participateCountLabel.attributedText = fullString
    }
    
    public func setSkeletonCardView() {
        self.backgroundColor = hexStringToUIColor(hex: "F1F1F1")
        setIconContents(data: "")
        groupNameLabel.text = ""
        createdDateLabel.text = ""
        participateCountLabel.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setParticipateCountLabel() {
        contentView.addSubview(participateCountLabel)
        participateCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            participateCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
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
            iconView.text = ""
        }
    }
    
    private func setIcon() {
        contentView.addSubview(iconView)
        self.clipsToBounds = true
        contentView.clipsToBounds = true
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 2.0),
            iconView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 2.0),
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
        contentView.addSubview(groupNameLabel)
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
            groupNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
        ])
        groupNameLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        groupNameLabel.textAlignment = .left
        groupNameLabel.textColor = .systemBlack
    }
    
    private func setCreatedDateLabel() {
        contentView.addSubview(createdDateLabel)
        createdDateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createdDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            createdDateLabel.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor, constant: 12),
        ])
        createdDateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        createdDateLabel.textAlignment = .left
        createdDateLabel.textColor = .systemBlack
        createdDateLabel.layer.opacity = 0.75
    }
}
