//
//  ConfirmGroupCardView.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/09.
//

import UIKit

final class ConfirmGroupCardView: UIView {
    private let groupNameLabel = UILabel()
    private let dateStringLabel = UILabel()
    
    init(groupName: String, date: Date) {
        super.init(frame: .zero)
        setGroupNameLabel(groupName: groupName)
        setDateStringLabel(dateString: date.toString_ConfirmCreatingGroup())
        self.layer.cornerRadius = 16.0
        self.backgroundColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ConfirmGroupCardView {
    func setGroupNameLabel(groupName: String) {
        self.addSubview(groupNameLabel)
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            groupNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
        ])
        groupNameLabel.text = groupName
    }
    
    func setDateStringLabel(dateString: String) {
        self.addSubview(dateStringLabel)
        dateStringLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateStringLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            dateStringLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        ])
        dateStringLabel.text = dateString
    }
}
