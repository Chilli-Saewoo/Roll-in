//
//  SelectBackgroundColorCell.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/10.
//

import UIKit

final class SelectBackgroundColorCell: UICollectionViewCell {
    var colorBackgroundView = UIView()
    var textMessageLabel = UILabel()
    var colorNameLabel = UILabel()
    var isActivate = false
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCell()
        setUpLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpCell()
        setUpLabel()
    }
    
    public func setCellContents(data: BackgroundColorSet) {
        colorBackgroundView.backgroundColor = hexStringToUIColor(hex: data.backgroundColorString)
        textMessageLabel.textColor = hexStringToUIColor(hex: data.textColorString)
        colorNameLabel.text = data.colorName
    }
    
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
        
        contentView.addSubview(colorNameLabel)
        colorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorNameLabel.topAnchor.constraint(equalTo: colorBackgroundView.bottomAnchor, constant: 8),
        ])
        colorNameLabel.font = .systemFont(ofSize: 12, weight: .regular)
        colorNameLabel.textAlignment = .center
        colorNameLabel.text = "노랑"
        
    }
    private func setUpLabel() {
        textMessageLabel.font = .systemFont(ofSize: 16, weight: .regular)
        textMessageLabel.text = "안녕..."
        textMessageLabel.textAlignment = .center
    }
}
