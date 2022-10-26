//
//  Note.swift
//  RollIn
//
//  Created by Noah Park on 2022/10/26.
//

import Foundation

struct Note: Equatable, Comparable {
    let id: String
    let timeStamp: Date
    let sender: String
    let image: Int
    let message: String
    
    static func < (lhs: Note, rhs: Note) -> Bool {
        return lhs.timeStamp < rhs.timeStamp
    }
    
}
