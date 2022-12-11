//
//  PostData.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/27.
//

import Foundation

enum PostType: String {
    case imageAndMessage = "imageAndMessage"
    case image = "image"
    case message = "message"
}

struct PostCodableData: Codable {
    var timeStamp: Date
    var isPublic: Bool
    var postTheme: String?
    var message: String?
    var from: String
    var image: String?
}

class PostData: Equatable, Comparable {
    let type: PostType
    let id: String
    let timestamp: Date
    let from: String
    let isPublic: Bool
    
    init(type: PostType, id: String, timestamp: Date, from: String, isPublic: Bool) {
        self.type = type
        self.id = id
        self.timestamp = timestamp
        self.from = from
        self.isPublic = isPublic
    }
    
    static func < (lhs: PostData, rhs: PostData) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
    
    static func == (lhs: PostData, rhs: PostData) -> Bool {
        return lhs.id == rhs.id
    }
}

final class PostWithImageAndMessage: PostData {
    var imageURL: String?
    var message: String
    var postTheme: String
    
    init(type: PostType, id: String, timestamp: Date, from: String, isPublic: Bool, imageURL: String?, message: String, postTheme: String) {
        self.imageURL = imageURL
        self.message = message
        self.postTheme = postTheme
        super.init(type: type, id: id, timestamp: timestamp, from: from, isPublic: isPublic)
    }
}
