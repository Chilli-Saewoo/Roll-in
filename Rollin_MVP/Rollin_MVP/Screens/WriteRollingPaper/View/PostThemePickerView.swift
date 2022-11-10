//
//  PostThemePickerView.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/09.
//

import UIKit

protocol PostViewDelegate: AnyObject {
    func changePostColor(selectedColor: UIColor)
}

final class PostThemePickerView: UIView {

    struct theme {
        let textColor: UIColor
        let bgColor: UIColor
        let title: String
    }
    
    weak var delegate: PostViewDelegate?

    private var themeList: [theme] = [theme(textColor: .textRed, bgColor: .bgRed, title: "빨강"),
                                      theme(textColor: .textYellow, bgColor: .bgYellow, title: "노랑"),
                                      theme(textColor: .textGreen, bgColor: .bgGreen, title: "초록"),
                                      theme(textColor: .textBlue, bgColor: .bgBlue, title: "파랑"),
                                      theme(textColor: .textPurple, bgColor: .bgPurple, title: "보라")]
    
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
            cell.themeLabel.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            cell.themeLabel.layer.borderWidth = 2
        }
        
        cell.themeTitleLabel.text = themeList[indexPath.row].title
        cell.themeLabel.textColor = themeList[indexPath.row].textColor
        cell.themeLabel.backgroundColor = themeList[indexPath.row].bgColor
        
        return cell
    }
}

extension PostThemePickerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PostThemePickerViewCell else { return }
        
        cell.isSelectedTheme = true
        cell.themeLabel.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        cell.themeLabel.layer.borderWidth = 2
        
        if indexPath.row != 0 {
            guard let firstCell = collectionView.cellForItem(at: [0, 0]) as? PostThemePickerViewCell else { return }
            firstCell.isSelectedTheme = false
            firstCell.themeLabel.layer.borderWidth = 0
        }
        delegate?.changePostColor(selectedColor: themeList[indexPath.row].bgColor)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PostThemePickerViewCell else { return }
        cell.isSelectedTheme = false
        cell.themeLabel.layer.borderWidth = 0
    }
}
