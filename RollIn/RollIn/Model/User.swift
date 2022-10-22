//
//  User.swift
//  RollIn
//
//  Created by Noah Park on 2022/10/22.
//

import Foundation

struct User: Equatable {
    let id: UUID
    let nickname: String
    
    init(id: UUID, nickname: String) {
        self.id = id
        self.nickname = nickname
    }
}
