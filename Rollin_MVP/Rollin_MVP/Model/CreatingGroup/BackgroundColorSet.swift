//
//  BackgroundColorSet.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/11.
//

import Foundation

final class BackgroundColorSet {
    static let datas = [
        BackgroundColorSet(backgroundColorString: "FEE0EA",
                           textColorString: "D61951",
                           colorName: "빨강"),
        BackgroundColorSet(backgroundColorString: "FFF9C0",
                           textColorString: "935800",
                           colorName: "노랑"),
        BackgroundColorSet(backgroundColorString: "C8F6D5",
                           textColorString: "15843B",
                           colorName: "초록"),
        BackgroundColorSet(backgroundColorString: "DDEBFF",
                           textColorString: "4069CE",
                           colorName: "파랑"),
        BackgroundColorSet(backgroundColorString: "EBDDFF",
                           textColorString: "4D2980",
                           colorName: "보라"),
    ]
    
    let backgroundColorString: String
    let textColorString: String
    let colorName: String
    
    init(backgroundColorString: String, textColorString: String, colorName: String) {
        self.backgroundColorString = backgroundColorString
        self.textColorString = textColorString
        self.colorName = colorName
    }
}
