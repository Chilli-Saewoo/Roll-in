//
//  IndexBarTableViewCell.swift
//  Rollin_MVP
//
//  Created by 한택환 on 2022/12/11.
//

import UIKit

class IndexBarTableViewCell: UITableViewCell {
    private let alphabetIndexLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupLayout(){
        addSubview(alphabetIndexLabel)
        alphabetIndexLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alphabetIndexLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            alphabetIndexLabel.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
    
    func configureUI(title: String) {
        self.alphabetIndexLabel.text = title
        self.alphabetIndexLabel.textColor = .white
        self.alphabetIndexLabel.backgroundColor = .clear
    }
}
