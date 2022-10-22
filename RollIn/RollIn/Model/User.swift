//
//  User.swift
//  RollIn
//
//  Created by Noah Park on 2022/10/22.
//

import Foundation

struct User: Equatable {
    let id = UUID()
    let nickname: String
    
    init(nickname: String) {
        self.nickname = nickname
    }
}
