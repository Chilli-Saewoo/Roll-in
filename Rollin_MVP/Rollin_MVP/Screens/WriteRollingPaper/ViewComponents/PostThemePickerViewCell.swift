//
//  WriteRollingPaperCollectionViewCell.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/09.
//

import UIKit

final class PostThemePickerViewCell: UICollectionViewCell {
    
    var themeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.textColor = .red
        label.text = "롤인"
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(themeLabel)
        themeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            themeLabel.topAnchor.constraint(equalTo: topAnchor),
            themeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            themeLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - (7 * 3) - (16 * 2))/4),
            themeLabel.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - (7 * 3) - (16 * 2))/4),
        ])
    }
}
