//
//  SelectIconCell.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/11.
//

import UIKit

func hexStringToUIColor(hex: String) -> UIColor {
    var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

final class SelectIconCell: UICollectionViewCell {
    var colorBackgroundView = UIView()
    var textMessageLabel = UILabel()
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    var isActivate = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCell()
        setUpImageView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpCell()
        setUpImageView()
    }
    
    public func setCellContents(data: IconsSet) {
        switch data.imageName {
        case "school":
            textMessageLabel.text = "🏫"
        case "tree":
            textMessageLabel.text = "🎄"
        case "congratulate":
            textMessageLabel.text = "🎉"
        case "smile":
            textMessageLabel.text = "😀"
        case "heart":
            textMessageLabel.text = "❤️"
        default:
            textMessageLabel.text = "❤️"
        }
    }
    
    public func activateCell() {
        colorBackgroundView.layer.borderWidth = 2.0
        colorBackgroundView.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1.0)
    }
    
    public func inactivateCell() {
        colorBackgroundView.layer.borderWidth = 0.0
    }
    
    private func setUpCell() {
        contentView.addSubview(colorBackgroundView)
        colorBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorBackgroundView.widthAnchor.constraint(equalTo: self.widthAnchor),
            colorBackgroundView.heightAnchor.constraint(equalTo: self.widthAnchor),
            colorBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            colorBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        ])
        colorBackgroundView.backgroundColor = .yellow
        colorBackgroundView.layer.cornerRadius = 4.0
        
        contentView.addSubview(textMessageLabel)
        textMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textMessageLabel.centerXAnchor.constraint(equalTo: colorBackgroundView.centerXAnchor),
            textMessageLabel.centerYAnchor.constraint(equalTo: colorBackgroundView.centerYAnchor),
        ])
        
        colorBackgroundView.backgroundColor = hexStringToUIColor(hex: "E9E9E9")
    }
    private func setUpImageView() {
        textMessageLabel.font = .systemFont(ofSize: 54, weight: .medium)
    }
}

