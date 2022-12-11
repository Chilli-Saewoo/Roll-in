//
//  PostPhotoPickerView.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/12/12.
//

import UIKit

final class PostPhotoPickerView: UIView {
    
    private lazy var deletePhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.backgroundColor = .bgGray
        button.tintColor = .systemBlack
        button.layer.cornerRadius = 4
        return button
    }()
    
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.backgroundColor = .bgGray
        button.tintColor = .systemBlack
        button.layer.cornerRadius = 4
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        addSubview(deletePhotoButton)
        deletePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deletePhotoButton.topAnchor.constraint(equalTo: topAnchor),
            deletePhotoButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            deletePhotoButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            deletePhotoButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -4)
        ])
        
        addSubview(addPhotoButton)
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addPhotoButton.topAnchor.constraint(equalTo: topAnchor),
            addPhotoButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addPhotoButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            addPhotoButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 4)
        ])
    }
    
}

