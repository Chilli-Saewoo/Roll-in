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
    let timeStamp: Date
    
    static func < (lhs: User, rhs: User) -> Bool {
            return lhs.timeStamp < rhs.timeStamp
    }
}

struct ContentView: View {
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @State var twoDimUsers: [[User]] = [[]]
    @State var showingUsers: [User] = []
    @State var currentIndex = 0
    @State var pages = 0
    private let ref = Database.database().reference()
    var ciContext = CIContext()
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    
    func qrCodeImage(for string: String) -> Image? {
        let data = string.data(using: String.Encoding.utf8)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let ciImage = qrFilter.outputImage else { return nil }
        let transformed = ciImage.transformed(by: CGAffineTransform.init(scaleX: 20, y: 20))
        let cgImage = ciContext.createCGImage(transformed, from: transformed.extent)
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
                .frame(width: 931, height: 458, alignment: .topLeading)
                .padding(EdgeInsets(top: 250, leading: 120, bottom:43, trailing: 120))
                ZStack{
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(red: 0 / 255, green: 0 / 255, blue: 0 / 255))
                        .opacity(0.5)
                        .frame(width: (15 * (CGFloat(pages) + 2)) + (8 * CGFloat(pages)), height: 20)
                    HStack{
                        ForEach(0 ..< pages, id: \.self) { page in
                            if page == currentIndex {
                                Circle()
                                    .fill(Color(red: 255 / 255, green: 114 / 255, blue: 66 / 255))
                                    .frame(width: 8, height: 8)
                                    .padding(EdgeInsets(top: 0, leading: 7, bottom:0, trailing: 7))
                            }
                            else {
                                Circle()
                                    .fill(Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255))
                                    .frame(width: 8, height: 8)
                                    .padding(EdgeInsets(top: 0, leading: 7, bottom:0, trailing: 7))
                            }
                            
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom:79, trailing: 0))
            }
        }
        .onAppear {
            self.ref.child("users").observe(.value) { snapshot in
                let values = snapshot.value as? [String: [String: AnyObject]] ?? [:]
                let users: [User] = values.map {
                    let id = $0.key
                    let nickname = $0.value["nickname"] as? String ?? ""
                    let addedDateString = $0.value["timestamp"] as? String ?? ""
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd HH:mm:ss"
                    formatter.timeZone = TimeZone(identifier: "UTC")
                    let dateObject = formatter.date(from: addedDateString) ?? Date()
                    return User(id: id, nickname: nickname, timeStamp: dateObject)
                }.sorted(by: <)
                
                pages = (users.count / 15) + 1
                if users.count != 0 && users.count % 15 == 0 {
                    pages -= 1
                }
                let twoDimArray = Array(repeating: Array(repeating: 0, count: 15), count: pages)
                var iter = users.makeIterator()
                let newArray = twoDimArray.map { $0.compactMap{ _ in iter.next() }}
                
                showingUsers = newArray.first ?? []
                twoDimUsers = newArray
            }
        }
        .onReceive(timer) { _ in
            
            currentIndex += 1
            if currentIndex >= twoDimUsers.count {
                currentIndex = 0
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
