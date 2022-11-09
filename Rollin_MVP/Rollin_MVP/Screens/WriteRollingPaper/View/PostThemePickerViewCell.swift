//
//  WriteRollingPaperCollectionViewCell.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/09.
//

import UIKit

final class PostThemePickerViewCell: UICollectionViewCell {
    
    var isSelectedTheme: Bool = false
    
    lazy var themeView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .red
        uiView.layer.cornerRadius = 12.5
        return uiView
    }()
    
    var themeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sunset"
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
        addSubview(themeView)
        themeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            themeView.topAnchor.constraint(equalTo: topAnchor),
            themeView.centerXAnchor.constraint(equalTo: centerXAnchor),
            themeView.widthAnchor.constraint(equalToConstant: 63),
            themeView.heightAnchor.constraint(equalToConstant: 63),
        ])
        
        addSubview(themeTitleLabel)
        themeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            themeTitleLabel.topAnchor.constraint(equalTo: themeView.bottomAnchor, constant: 4.7),
            themeTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
