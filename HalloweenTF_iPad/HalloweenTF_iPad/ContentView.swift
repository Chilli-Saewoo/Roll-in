//
//  ContentView.swift
//  HalloweenTF_iPad
//
//  Created by Yeji on 2022/10/24.
//

import SwiftUI
import Firebase
import UIKit

struct User: Identifiable, Hashable {
    let id: String
    let nickname: String
}

struct ContentView: View {
    @State var users: [User] = []
    private let ref = Database.database().reference()
    var ciContext = CIContext()

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
            VStack {
                HStack(spacing: 10) {
                    ForEach(users, id: \.self) { user in
                        
                        let url = "https://chilli-saewoo.github.io/rollin.github.io/write?id=" + user.id
                        let image = qrCodeImage(for: url)!
                    
                        image
                            .resizable()
                            .frame(width: 100, height: 100)
                            .tint(.brown)
                            .foregroundColor(.green)
                        
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
