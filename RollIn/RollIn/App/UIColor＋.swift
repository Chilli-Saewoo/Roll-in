//
//  UIColor＋.swift
//  RollIn
//
//  Created by Seungyun Kim on 2022/10/26.
//

import UIKit

extension UIColor {
    
    //MARK: UIColor
    static var hwOrange: UIColor {
        return UIColor(hex: "#FF7242")
    }
    
    static var hwOrangeInactive: UIColor {
        return UIColor(hex: "#FFB197")
    }
    
    static var CustomBackgroundColor: UIColor {
        return UIColor(hex: "#2A2A2A")
    }
    
    //MARK: TextColor
    static var hwTextOrange: UIColor {
        return UIColor(hex: "#FF8961")
    }
    
    static var hwTextBlack: UIColor {
        return UIColor(hex: "#202020")
    }
    
    static var hwTextRealBlack: UIColor {
        return UIColor(hex: "#101010")
    }
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
