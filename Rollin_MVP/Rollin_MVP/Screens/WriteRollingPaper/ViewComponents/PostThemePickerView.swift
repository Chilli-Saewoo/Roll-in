//
//  PostThemePickerView.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/09.
//

import UIKit

final class PostThemePickerView: UIView {

    struct theme {
        let textColor: UIColor
        let bgColor: UIColor
        let title: String
        let themeName: String
    }
    
    weak var postViewDelegate: PostViewDelegate?

    private var themeList: [theme] = [theme(textColor: .textRed, bgColor: .bgRed, title: "빨강", themeName: "FEE0EA"),
                                      theme(textColor: .textYellow, bgColor: .bgYellow, title: "노랑", themeName: "FFF9C0"),
                                      theme(textColor: .textGreen, bgColor: .bgGreen, title: "초록", themeName: "C8F6D5"),
                                      theme(textColor: .textBlue, bgColor: .bgBlue, title: "파랑", themeName: "DDEBFF"),
                                      theme(textColor: .textGold, bgColor: .clear, title: "보라", themeName: "mistletoe"),
                                      theme(textColor: .textBrown, bgColor: .clear, title: "빨강", themeName: "light"),
                                      theme(textColor: .textBrown, bgColor: .clear, title: "노랑", themeName: "orangeStripe"),
                                      theme(textColor: .textRed, bgColor: .clear, title: "초록", themeName: "redStripe"),
                                      theme(textColor: .textGold, bgColor: .clear, title: "파랑", themeName: "deer"),
                                      theme(textColor: .white, bgColor: .clear, title: "보라", themeName: "snowman"),
                                      theme(textColor: .white, bgColor: .clear, title: "파랑", themeName: "gingerBread"),
                                      theme(textColor: .white, bgColor: .clear, title: "보라", themeName: "santa")]
    
    let postThemePickerItemWidth = (UIScreen.main.bounds.width - (7 * 3) - (16 * 2))/4
    
    var selectedThemeHex: String = "FEE0EA"
    
    private lazy var themeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 7
        layout.itemSize = CGSize(width: postThemePickerItemWidth, height: postThemePickerItemWidth)
       
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
    
    private func setupLayout() {
        addSubview(themeCollectionView)
        NSLayoutConstraint.activate([
            themeCollectionView.topAnchor.constraint(equalTo: topAnchor),
            themeCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            themeCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            themeCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupCollectionView() {
        themeCollectionView.dataSource = self
        themeCollectionView.delegate = self
        themeCollectionView.register(PostThemePickerViewCell.self, forCellWithReuseIdentifier: PostThemePickerViewCell.className)
    }
    
    func stringToImage(imageString: String) -> UIImage {
        switch imageString {
        case "mistletoe" :
            return UIImage(named: "mistletoe") ?? UIImage()
        case "light" :
            return UIImage(named: "light") ?? UIImage()
        case "orangeStripe" :
            return UIImage(named: "orangeStripe") ?? UIImage()
        case "redStripe" :
            return UIImage(named: "redStripe") ?? UIImage()
        case "deer" :
            return UIImage(named: "deer") ?? UIImage()
        case "snowman" :
            return UIImage(named: "snowman") ?? UIImage()
        case "gingerBread" :
            return UIImage(named: "gingerBread") ?? UIImage()
        case "santa" :
            return UIImage(named: "santa") ?? UIImage()
        default:
            return UIImage()
        }
    }
}

extension PostThemePickerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        themeList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostThemePickerViewCell.className, for: indexPath) as? PostThemePickerViewCell else { return UICollectionViewCell() }
        let image = stringToImage(imageString: themeList[indexPath.row].themeName)
        if indexPath.row == 0 {
            cell.themeLabel.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            cell.themeLabel.layer.borderWidth = 2
        }
        cell.imageView.image = image
        cell.themeLabel.textColor = themeList[indexPath.row].textColor
        cell.themeLabel.backgroundColor = themeList[indexPath.row].bgColor
        
        return cell
    }
}

extension PostThemePickerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PostThemePickerViewCell else { return }
        
        selectedThemeHex = themeList[indexPath.row].themeName
        cell.themeLabel.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        cell.themeLabel.layer.borderWidth = 2
        
        if indexPath.row != 0 {
            guard let firstCell = collectionView.cellForItem(at: [0, 0]) as? PostThemePickerViewCell else { return }
            firstCell.themeLabel.layer.borderWidth = 0
        }
        postViewDelegate?.changePostColor(selectedTextColor: themeList[indexPath.row].textColor, selectedBgColor: themeList[indexPath.row].bgColor)
        postViewDelegate?.changePostTheme(theme: themeList[indexPath.row].themeName)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PostThemePickerViewCell else { return }
        cell.themeLabel.layer.borderWidth = 0
    }
}
