//
//  Group.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/13.
//

import UIKit

// code: "ASDFS"
// groupName: "칠리새우"
// groupTheme: "red"
// groupIcon: "school"
// timestamp: 1234555666666

final class Group: Codable, Comparable {
    let groupName: String
    let groupTheme: String
    let groupIcon: String
    let code: String
    let timestamp: Date
    var groupId: String?
    var groupNickname: String?
    var participants: [(String, String)] = []
    
    enum CodingKeys: String, CodingKey {
        case groupName
        case groupTheme
        case groupIcon
        case code
        case timestamp
    }
    
    static func < (lhs: Group, rhs: Group) -> Bool {
        lhs.timestamp < rhs.timestamp
    }
    
    static func == (lhs: Group, rhs: Group) -> Bool {
        lhs.code == rhs.code
    }
    
}
