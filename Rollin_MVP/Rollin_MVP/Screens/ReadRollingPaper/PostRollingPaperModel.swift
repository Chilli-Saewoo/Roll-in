//
//  PostRollingPaperModel.swift
//  Rollin_MVP
//
//  Created by Yoonjae on 2022/11/12.
//

import UIKit

struct MyModel {
    let color: UIColor
    let commentString: String
    let imageString: UIImage
    let contentHeightSize: CGFloat

    static func getMock() -> [Self] {

        var datas: [MyModel] = []

        let number = 29 // 0 ~ 29
        for i in 0...number {
            let red = CGFloat(arc4random_uniform(256))
            let green = CGFloat(arc4random_uniform(256))
            let blue = CGFloat(arc4random_uniform(256))
            let alpha = CGFloat(drand48()) // 0 ~ 1

            let color = UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
            let myImage: UIImage = UIImage(named: "cat") ?? UIImage()
            let tmpHeight = CGFloat(arc4random_uniform(500))
            let myModel: MyModel = .init(color: color,
                                         commentString: "\(i + 1) cell", imageString: myImage,
                                         contentHeightSize: tmpHeight)
            datas += [myModel]
        }

        return datas
    }
}


