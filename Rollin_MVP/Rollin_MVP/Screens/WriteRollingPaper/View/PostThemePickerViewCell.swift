//
//  WriteRollingPaperCollectionViewCell.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/09.
//

import UIKit

final class PostThemePickerViewCell: UICollectionViewCell {
    
    var isSelectedTheme: Bool = false
    
    var themeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.textColor = .red
        label.text = "안녕.."
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()
    
    var themeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .preferredFont(forTextStyle: .footnote)
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
            themeLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - (7 * 4) - (21 * 2))/5),
            themeLabel.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - (7 * 4) - (21 * 2))/5),
        ])
        
        addSubview(themeTitleLabel)
        themeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            themeTitleLabel.topAnchor.constraint(equalTo: themeLabel.bottomAnchor, constant: 8),
            themeTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
