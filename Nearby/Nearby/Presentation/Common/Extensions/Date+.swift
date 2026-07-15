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
        let format = Calendar.current.component(.minute, from: self) == 0
            ? "M월 d일 (E) a h시"
            : "M월 d일 (E) a h시 m분"
        let formatter = DateFormatter.cached(format: format)
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    var timeDisplayText: String {
        let format = Calendar.current.component(.minute, from: self) == 0
            ? "a h시"
            : "a h시 m분"
        let formatter = DateFormatter.cached(format: format)
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
}
