//
//  PostRollingPaperModel.swift
//  Rollin_MVP
//
//  Created by Yoonjae on 2022/11/12.
//

import UIKit

struct PostRollingPaperModel: Comparable {
    let id = UUID()
    let color: UIColor
    let commentString: String
    let image: UIImage
    let timestamp: Date
    let from: String
    
    static func < (lhs: PostRollingPaperModel, rhs: PostRollingPaperModel) -> Bool {
        lhs.timestamp < rhs.timestamp
    }

    static func == (lhs: PostRollingPaperModel, rhs: PostRollingPaperModel) -> Bool {
        lhs.id == rhs.id
    }
    
    private let rollingPaperPostAPI = RollingPaperPostAPI()

    // 현재 임의의 색깔이 들어가있는 상태이므로 추후에 변경될 예정입니다.
    static func getMock() -> [Self] {

        var datas: [PostRollingPaperModel] = []

        let number = 29 // 0 ~ 29
        for _ in 0...number {
            let red = CGFloat(arc4random_uniform(256))
            let green = CGFloat(arc4random_uniform(256))
            let blue = CGFloat(arc4random_uniform(256))
            let alpha = CGFloat(drand48()) // 0 ~ 1
            
            let string = " Pinterest에서 김수아님의 보드 예쁜고양이 사진을(를) 팔로우하세요. 예쁜 고양이, 동물, 고양이에 관한 아이디어를 더 확인해 보세요. Pinterest에서 김수아님의 보드 예쁜고양이 사진을(를) 팔로우하세요. 예쁜 고양이, 동물, 고양이에 관한 아이디어를 더 확인해 보세요."
            let endIdx:String.Index = string.index(string.startIndex, offsetBy: Int.random(in: 0...40))
            let dummyIdx = String(string[...endIdx])
            let color = UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
            let myImage: UIImage = UIImage(named: "cat")?.resizeImage(newWidth: UIScreen.main.bounds.width-128) ?? UIImage()
            print((UIScreen.main.bounds.width)/2)
            let myModel: PostRollingPaperModel = .init(color: color,
                                                       commentString: dummyIdx, image: myImage, timestamp: Date(), from: "")
            datas += [myModel]
        }

        return datas
    }
}


