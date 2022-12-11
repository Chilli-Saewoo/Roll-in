//
//  UIColor+.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/10.
//

import UIKit

extension UIColor {
    
    //MARK: Background Color
    static let inactiveBgGray = UIColor(named: "inactiveBgGray") ?? .black
    
    static let bgBlue = UIColor(named: "bgBlue") ?? .black
    
    static let bgGreen = UIColor(named: "bgGreen") ?? .black
    
    static let bgPurple = UIColor(named: "bgPurple") ?? .black
    
    static let bgRed = UIColor(named: "bgRed") ?? .black
    
    static let bgYellow = UIColor(named: "bgYellow") ?? .black
    
    //MARK: Text Color
    static let systemBlack = UIColor(named: "systemBlack") ?? .white
    
    static let inactiveTextGray = UIColor(named: "inactiveTextGray") ?? .black
    
    static let textBlue = UIColor(named: "textBlue") ?? .black
    
    static let textGreen = UIColor(named: "textGreen") ?? .black
    
    static let textPurple = UIColor(named: "textPurple") ?? .black
    
    static let textRed = UIColor(named: "textRed") ?? .black
    
    static let textYellow = UIColor(named: "textYellow") ?? .black
    
    static let cardBlue = UIColor(named: "cardBlue") ?? .black
    
    static let cardDeepBlue = UIColor(named: "cardDeepBlue") ?? .black
    
    static let cardGreen = UIColor(named: "cardGreen") ?? .black
    
    static let cardPink = UIColor(named: "cardPink") ?? .black
    
    static let cardPurple = UIColor(named: "cardPurple") ?? .black
    
    static let cardRed = UIColor(named: "cardRed") ?? .black
    
    static let cardYellow = UIColor(named: "cardYellow") ?? .black
    
    static let skeletonRed = UIColor(named: "skeletonRed") ?? .black
    
    static let skeletonYellow = UIColor(named: "skeletonYellow") ?? .black
    
    static let skeletonGreen = UIColor(named: "skeletonGreen") ?? .black
    
    static let skeletonBlue = UIColor(named: "skeletonBlue") ?? .black
    
    static let skeletonPurple = UIColor(named: "skeletonPurple") ?? .black
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
