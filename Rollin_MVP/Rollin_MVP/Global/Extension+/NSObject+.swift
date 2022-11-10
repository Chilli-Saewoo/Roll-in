//
//  NSObject+Extension.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/09.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
