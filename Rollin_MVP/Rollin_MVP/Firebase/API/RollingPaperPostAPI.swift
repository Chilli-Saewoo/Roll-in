//
//  RollingPaperPostAPI.swift
//  Rollin_MVP
//
//  Created by Seungyun Kim on 2022/11/11.
//

import Foundation

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RollingPaperPostAPI {
    
    private let db = FirebaseFirestore.Firestore.firestore()
    
    func writePost(document: RollingPaperPostData) async throws {
        let group = "fa8cce5a-1522-473e-9eb4-08aae407b015"
        let user = "rmEM5tNdBP7bi1v8Jgi4"
        
        let reference = try db.collection("groupUsers").document(group).collection("participants").document(user).collection("posts").addDocument(from: document)
        let result: () = try await reference.updateData(["timeStamp" : FieldValue.serverTimestamp()])
        
        return result
    }
}
