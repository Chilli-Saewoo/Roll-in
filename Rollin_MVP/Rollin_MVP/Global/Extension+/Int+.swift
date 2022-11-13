//
//  Int+.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/12.
//

import Foundation

extension Int {
    func randomString() -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0 ..< self).map{ _ in letters.randomElement()! })
    }
}
