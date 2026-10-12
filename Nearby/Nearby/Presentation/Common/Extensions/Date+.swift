//
//  Date+.swift
//  Nearby
//
//  Created by soomin on 7/2/26.
//

import Foundation

enum NearbyDateParser {
    private static let localDateFormats = [
        "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS",
        "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",
        "yyyy-MM-dd'T'HH:mm:ss.SSS",
        "yyyy-MM-dd'T'HH:mm:ss",
        "yyyy-MM-dd'T'HH:mm"
    ]

    static func parseInstant(_ value: String?) -> Date? {
        guard let value else { return nil }

        if let date = ISO8601DateFormatter.withFractionalSeconds.date(from: value)
            ?? ISO8601DateFormatter.standard.date(from: value) {
            return date
        }

        return parseLocal(value, timeZone: TimeZone(secondsFromGMT: 0))
    }

    static func parseLocal(_ value: String?, timeZoneID: String?) -> Date? {
        parseLocal(value, timeZone: timeZoneID.flatMap(TimeZone.init(identifier:)) ?? .nearbyAPITimeZone)
    }

    private static func parseLocal(_ value: String?, timeZone: TimeZone?) -> Date? {
        guard let value else { return nil }

        if let date = ISO8601DateFormatter.withFractionalSeconds.date(from: value)
            ?? ISO8601DateFormatter.standard.date(from: value) {
            return date
        }

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = timeZone

        for format in localDateFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: value) { return date }
        }
        return nil
    }
}

extension Date {
    var apiDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .nearbyAPITimeZone
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.string(from: self)
    }

    func toFormattedString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    var meetingDisplayText: String {
        let format = Calendar.current.component(.minute, from: self) == 0 ? "M월 d일 (E) a h시" : "M월 d일 (E) a h시 m분"
        let formatter = DateFormatter.cached(format: format)
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    var timeDisplayText: String {
        let format = Calendar.current.component(.minute, from: self) == 0 ? "a h시" : "a h시 m분"
        let formatter = DateFormatter.cached(format: format)
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

extension TimeZone {
    static var nearbyAPITimeZone: TimeZone {
        TimeZone(identifier: "Asia/Seoul") ?? current
    }
}
