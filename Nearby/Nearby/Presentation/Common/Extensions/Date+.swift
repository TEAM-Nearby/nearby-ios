//
//  Date+.swift
//  Nearby
//
//  Created by soomin on 7/2/26.
//

import Foundation

extension Date {
    func toFormattedString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    var meetingDisplayText: String {
        let formatter = DateFormatter.cached(format: "M월 d일 (E) a h시 m분")
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    var timeDisplayText: String {
        let formatter = DateFormatter.cached(format: "a h시 m분")
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    var alarmMeetingDisplayText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy년 M월 d일 예정"

        return formatter.string(from: self)
    }
}
