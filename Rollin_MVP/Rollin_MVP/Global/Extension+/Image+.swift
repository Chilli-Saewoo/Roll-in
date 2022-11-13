//
//  Image+.swift
//  Rollin_MVP
//
//  Created by Yoonjae on 2022/11/13.
//

import Foundation
import UIKit

extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage
    }
}
