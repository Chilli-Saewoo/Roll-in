//
//  RollingPaperPostModel.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/11.
//

import Foundation

import FirebaseFirestore

struct RollingPaperPostData: Codable {
    var from: String
    var postTheme: String
    var message: String
    var image: String
    var isPublic: Bool
    let createdDate: FirebaseFirestore.Timestamp
}
