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
    
    func writePost(document: RollingPaperPostData, imageUrl: String) {
        let group = "fa8cce5a-1522-473e-9eb4-08aae407b015"
        let user = "rmEM5tNdBP7bi1v8Jgi4"
        let uuid = UUID().uuidString
        let batch = db.batch()
        
        batch.setData(["from": document.from,
                       "postTheme": document.postTheme,
                       "message": document.message,
                       "image": imageUrl,
                       "isPublic": document.isPublic,
                       "timeStamp": document.timeStamp], forDocument: db.collection("groupUsers").document(group).collection("participants").document(user).collection("posts").document(uuid), merge: true)
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
}
