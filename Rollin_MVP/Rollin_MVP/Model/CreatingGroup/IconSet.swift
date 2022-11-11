//
//  IconSet.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/11.
//

import Foundation

final class IconsSet {
    let imageName: String
    static let datas = [
        IconsSet(imageName: "school"),
        IconsSet(imageName: "tree"),
        IconsSet(imageName: "congratulate"),
        IconsSet(imageName: "smile"),
        IconsSet(imageName: "heart"),
    ]
    
    init(imageName: String) {
        self.imageName = imageName
    }
}
