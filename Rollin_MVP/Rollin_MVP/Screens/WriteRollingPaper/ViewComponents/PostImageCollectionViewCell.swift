//
//  PostImageTableViewCell.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/12/11.
//

import UIKit

final class PostImageCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.backgroundColor = .bgGray
        return imageView
    }()
    
    var photoLabel: UILabel = {
        let label = UILabel()
        label.text = "사진을 추가해주세요"
        return label
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDetailPostLayout()
    }
    
    private func setDetailPostLayout() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        addSubview(photoLabel)
        photoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            photoLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

