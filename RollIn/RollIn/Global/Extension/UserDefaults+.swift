//
//  UserDefaults+.swift
//  RollIn
//
//  Created by Noah Park on 2022/10/21.
//

import Foundation

extension UserDefaults {
    static var nickname: String? {
        set(newVal) {
            let defaults = UserDefaults.standard
            defaults.set(newVal, forKey: "nickname")
        }
        get {
            guard let nickname = UserDefaults.standard.string(forKey: "nickname")
            else {
                return nil
            }
            return nickname
        }
    }
}
