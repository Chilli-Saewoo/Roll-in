//
//  RollingpaperTableViewCell.swift
//  RollIn
//
//  Created by 한택환 on 2022/10/22.
//

import UIKit

final class RollingpaperTableViewCell: UITableViewCell {
    public lazy var writerNickname: UILabel = UILabel(frame: .zero)
    public lazy var message: UILabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension RollingpaperTableViewCell {
    func setUpView() {
        setWriterNickname()
        setMessage()
    }
    
    func setWriterNickname() {
        self.contentView.addSubview(writerNickname)
        writerNickname.translatesAutoresizingMaskIntoConstraints = false
        writerNickname.font = .preferredFont(forTextStyle: .body)
        writerNickname.textColor = .black
        NSLayoutConstraint.activate([
            writerNickname.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            writerNickname.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            writerNickname.widthAnchor.constraint(equalToConstant: 80),
            writerNickname.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setMessage() {
        self.contentView.addSubview(message)
        message.translatesAutoresizingMaskIntoConstraints = false
        message.font = .preferredFont(forTextStyle: .body)
        message.textColor = .black
        NSLayoutConstraint.activate([
            message.leadingAnchor.constraint(equalTo: writerNickname.trailingAnchor, constant: 15),
            message.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            message.widthAnchor.constraint(equalToConstant: 200),
            message.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
