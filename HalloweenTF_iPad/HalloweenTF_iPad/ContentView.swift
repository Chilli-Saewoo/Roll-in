//
//  ContentView.swift
//  HalloweenTF_iPad
//
//  Created by Yeji on 2022/10/24.
//

import SwiftUI
import Firebase
import UIKit

struct User: Identifiable, Hashable, Comparable {
    let id: String
    let nickname: String
    
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.nickname < rhs.nickname
    }
}

struct ContentView: View {
    let timer = Timer.publish(every: 7, on: .main, in: .common).autoconnect()
    @State var tempTwoDimUsers: [[User]] = [[]]
    @State var twoDimUsers: [[User]] = [[]]
    @State var showingUsers: [User] = []
    @State var currentIndex = 0
    private let ref = Database.database().reference()
    var ciContext = CIContext()
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    
    func qrCodeImage(for string: String) -> Image? {
        let data = string.data(using: String.Encoding.utf8)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let ciImage = qrFilter.outputImage else { return nil }
        let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent)
        let uiImage = UIImage(cgImage: cgImage!)
        let image = Image(uiImage: uiImage)
        return image
    }
    
    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack{
                LazyVGrid(columns: columns, spacing: 29) {
                    ForEach(showingUsers, id: \.self) { user in
                        VStack{
                            
                            let url = "https://chilli-saewoo.github.io/rollin.github.io/write/id=" + user.id
                            let qrimage = qrCodeImage(for: url)!
                            
                            qrimage
                                .resizable()
                                .frame(width: 107, height: 107)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom:13, trailing: 0))
                            
                            Text(user.nickname)
                                .foregroundColor(.white)
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .padding(.horizontal)
                    }
                }
                
            }
            .frame(width: 931, height: 458, alignment: .topLeading)
            .padding(EdgeInsets(top: 250, leading: 120, bottom:142, trailing: 120))
            
        }
        .onAppear {
            var isFirstAppeared = true
            self.ref.child("users").observe(.value) { snapshot in
                let values = snapshot.value as? [String: [String: AnyObject]] ?? [:]
                let users: [User] = values.map {
                    let id = $0.key
                    let nickname = $0.value["nickname"] as? String ?? ""
                    return User(id: id, nickname: nickname)
                }.sorted(by: <)
                
                var newIdx = users.count / 15
                if users.count != 0 && users.count % 15 == 0 {
                    newIdx -= 1
                }
                let twoDimArray = Array(repeating: Array(repeating: 0, count: 15), count: newIdx + 1)
                var iter = users.makeIterator()
                let newArray = twoDimArray.map { $0.compactMap{ _ in iter.next() }}
                tempTwoDimUsers = newArray
                if isFirstAppeared == true {
                    showingUsers = newArray.first ?? []
                    twoDimUsers = newArray
                    isFirstAppeared = false
                }
            }
        }
        .onReceive(timer) { _ in
            
            currentIndex += 1
            if currentIndex >= twoDimUsers.count {
                currentIndex = 0
            }
            if currentIndex == 0 {
                twoDimUsers = tempTwoDimUsers
            }
            showingUsers = twoDimUsers[currentIndex]
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
