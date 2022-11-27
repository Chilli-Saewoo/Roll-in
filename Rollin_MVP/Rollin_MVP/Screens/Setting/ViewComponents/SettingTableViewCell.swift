//
//  SettingTableViewCell.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/27.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    private let settingTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let navigationArrowImageView: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "chevron.forward"))
        image.tintColor = .systemBlack
        return image
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
        addSubview(settingTitleLabel)
        settingTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            settingTitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        addSubview(navigationArrowImageView)
        navigationArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationArrowImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            navigationArrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func configureUI(title: String, isArrowHidden: Bool, isRed: Bool) {
        self.settingTitleLabel.text = title
        if isRed {
            self.settingTitleLabel.textColor = .red
        }
        self.navigationArrowImageView.isHidden = isArrowHidden
    }
}
