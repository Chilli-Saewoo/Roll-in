//
//  ContentView.swift
//  HalloweenTF_iPad
//
//  Created by Yeji on 2022/10/24.
//

import SwiftUI
import Firebase

struct User: Identifiable, Hashable {
    let id: String
    let nickname: String
}

struct ContentView: View {
    @State var users: [User] = []
    private let ref = Database.database().reference()
    var body: some View {
        VStack {
            ForEach(users, id: \.self) { user in
                HStack(spacing: 10) {
                    Text(user.id)
                    Text(user.nickname)
                }
            }
        }
        .onAppear {
            self.ref.child("users").observe(.value) { snapshot in
                let value = snapshot.value as? [String: [String: AnyObject]] ?? [:]
                users = value.map { user in
                    let id = user.key
                    let nickname = user.value["nickname"] as? String ?? ""
                    return User(id: id, nickname: nickname)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
