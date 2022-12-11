//
//  PostPhotoPickerView.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/12/12.
//

import UIKit

final class PostPhotoPickerView: UIView {
    
    let postPhotoPickerItemWidth = (UIScreen.main.bounds.width - (7 * 3) - (16 * 2))/4
    
    private lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 7
        layout.itemSize = CGSize(width: postPhotoPickerItemWidth, height: postPhotoPickerItemWidth)
       
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        addSubview(photoCollectionView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupCollectionView() {
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        photoCollectionView.register(PostPhotoPickerViewCell.self, forCellWithReuseIdentifier: PostPhotoPickerViewCell.className)
    }
    
    
}

extension PostPhotoPickerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostPhotoPickerViewCell.className, for: indexPath) as? PostPhotoPickerViewCell else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            cell.imageView.removeFromSuperview()
            cell.setupButtonLayout()
            cell.button.setImage(UIImage(systemName: "xmark"), for: .normal)
            cell.imageView.backgroundColor = .bgGray
        } else if indexPath.row == 1 {
            cell.imageView.removeFromSuperview()
            cell.setupButtonLayout()
            cell.button.setImage(UIImage(systemName: "photo"), for: .normal)
            cell.imageView.backgroundColor = .bgGray
        } else {
            cell.imageView.backgroundColor = .bgGray
        }
        
        return cell
    }
    
    
}

extension PostPhotoPickerView: UICollectionViewDelegate {
    
}
