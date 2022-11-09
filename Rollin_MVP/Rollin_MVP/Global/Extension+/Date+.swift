//
//  Date+.swift
//  Rollin_MVP
//
//  Created by Noah Park on 2022/11/09.
//

import Foundation

extension Date {
    func toString_ConfirmCreatingGroup() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
}
