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
        DateFormatter.meetingDisplay.string(from: self)
    }
    
    // TODO: - 다른 브랜치에서 마저 작업
//    var timeDisplayText: String {
//        DateFormatter.timeDisplay.string(from: self)
//    }
}
