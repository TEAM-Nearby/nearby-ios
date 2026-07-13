//
//  DateFormatter+.swift
//  Nearby
//
//  Created by h2e on 7/12/26.
//

import Foundation

extension DateFormatter {
    static let serverDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }()
    
    static let meetingDisplay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 (E) a h시 mm분"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }()
    
    static let serverDateTimeWithZone: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
