//
//  UIView+.swift
//  RollIn
//
//  Created by Noah Park on 2022/10/22.
//

import UIKit

extension AppDelegate {
    static var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
}
