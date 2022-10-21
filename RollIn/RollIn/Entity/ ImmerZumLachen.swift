//
//  EntityExample.swift
//  RollIn
//
//  Created by Noah Park on 2022/10/21.
//


/// 해당 디렉토리는 사용하게 될 Model들을 모아놓는 디렉토리입니다.
/// 다음과 같이 enum, struct, class 등 여러가지가 올 수 있습니다.
enum LunchType: String {
    case Korean = "한식"
    case Japanese = "일식"
    case Western = "양식"
    case Chinese = "중식"
}

struct TodayLunch {
    let type: LunchType
    let restaurant: String
    let menus: [String]
    let price: Int
    let isWithVivi: Bool
}
