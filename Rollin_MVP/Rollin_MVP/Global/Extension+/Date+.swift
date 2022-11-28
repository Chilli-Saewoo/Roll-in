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
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
    
    func toString_koreaTime() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        let kr = dateFormatter.string(from: date)
        return kr
    }
}
