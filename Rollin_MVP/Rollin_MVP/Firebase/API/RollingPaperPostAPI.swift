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
    
    func writePost(document: RollingPaperPostData, imageUrl: String, groupId: String, receiver: String) {
        let groupId = groupId
        let receiver = receiver
        let uuid = UUID().uuidString
        let batch = db.batch()
        
        batch.setData(["from": document.from,
                       "postTheme": document.postTheme,
                       "message": document.message,
                       "image": imageUrl,
                       "isPublic": document.isPublic,
                       "timeStamp": document.timeStamp], forDocument: db.collection("groupUsers").document(groupId).collection("participants").document(receiver).collection("posts").document(uuid), merge: true)
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
}
