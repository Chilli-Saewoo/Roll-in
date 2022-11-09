//
//  PostThemePickerView.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/09.
//

import UIKit

final class PostThemePickerView: UIView {

    struct theme {
        let color: UIColor
        let title: String
    }

    private var themeList: [theme] = [theme(color: .red, title: "Apple"),
                                      theme(color: .blue, title: "Ocean"),
                                      theme(color: .green, title: "Forest"),
                                      theme(color: .yellow, title: "Lemon"),
                                      theme(color: .orange, title: "Sunset"),
                                      theme(color: .purple, title: "Cosmos"),
                                      theme(color: .magenta, title: "Pinkish")]

    private let themeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        layout.itemSize = CGSize(width: 63, height: 81)
       
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
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
    
    private func setupLayout() {
        addSubview(themeCollectionView)
        NSLayoutConstraint.activate([
            themeCollectionView.topAnchor.constraint(equalTo: topAnchor),
            themeCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            themeCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            themeCollectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func setupCollectionView() {
        themeCollectionView.dataSource = self
        themeCollectionView.delegate = self
        themeCollectionView.register(PostThemePickerViewCell.self, forCellWithReuseIdentifier: PostThemePickerViewCell.className)
    }
}

extension PostThemePickerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        themeList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostThemePickerViewCell.className, for: indexPath) as? PostThemePickerViewCell else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            cell.isSelectedTheme = true
            cell.themeView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            cell.themeView.layer.borderWidth = 3
        }
        
        cell.themeTitleLabel.text = themeList[indexPath.row].title
        cell.themeView.backgroundColor = themeList[indexPath.row].color
        
        return cell
    }
}

extension PostThemePickerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PostThemePickerViewCell else { return }
        
        cell.isSelectedTheme = true
        cell.themeView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        cell.themeView.layer.borderWidth = 3
        
        if indexPath.row != 0 {
            guard let firstCell = collectionView.cellForItem(at: [0, 0]) as? PostThemePickerViewCell else { return }
            firstCell.isSelectedTheme = false
            firstCell.themeView.layer.borderWidth = 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PostThemePickerViewCell else { return }
        cell.isSelectedTheme = false
        cell.themeView.layer.borderWidth = 0
    }
}
