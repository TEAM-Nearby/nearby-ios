//
//  Date+.swift
//  Nearby
//
//  Created by soomin on 7/2/26.
//

import CoreLocation
import Foundation

enum NearbyDateParser {
    private static let localDateFormats = [
        "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS",
        "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",
        "yyyy-MM-dd'T'HH:mm:ss.SSS",
        "yyyy-MM-dd'T'HH:mm:ss",
        "yyyy-MM-dd'T'HH:mm"
    ]

    static func reservationText(_ value: String?, hourFormat: String, minuteFormat: String) -> String? {
        guard let date = parseLocal(value, timeZoneID: "UTC") else { return nil }
        let timeZone = TimeZone.nearbyFallbackTimeZone
        let minute = Calendar(identifier: .gregorian).dateComponents(in: timeZone, from: date).minute
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = timeZone
        formatter.dateFormat = minute == 0 ? hourFormat : minuteFormat
        return formatter.string(from: date)
    }

    static func parseInstant(_ value: String?) -> Date? {
        guard let value else { return nil }

        if let date = ISO8601DateFormatter.withFractionalSeconds.date(from: value)
            ?? ISO8601DateFormatter.standard.date(from: value) {
            return date
        }

        return parseLocal(value, timeZone: TimeZone(secondsFromGMT: 0))
    }

    static func parseLocal(_ value: String?, timeZoneID: String?) -> Date? {
        parseLocal(value, timeZone: timeZoneID.flatMap(TimeZone.init(identifier:)) ?? .nearbyFallbackTimeZone)
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
    func nearbyReservationRequestString(timeZone: TimeZone) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = timeZone
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
    static let nearbyFallbackTimeZone = TimeZone(secondsFromGMT: 0) ?? TimeZone(identifier: "UTC") ?? .current

    static func nearbyPlaceTimeZone(latitude: Double, longitude: Double) -> TimeZone {
        let place = CLLocation(latitude: latitude, longitude: longitude)
        let cities: [(location: CLLocation, identifier: String)] = [
            (CLLocation(latitude: 41.3879706, longitude: 2.1671360), "Europe/Madrid"),
            (CLLocation(latitude: 40.4168, longitude: -3.7038), "Europe/Madrid"),
            (CLLocation(latitude: 48.8566, longitude: 2.3522), "Europe/Paris"),
            (CLLocation(latitude: 51.5074, longitude: -0.1278), "Europe/London")
        ]
        guard let nearest = cities.map({ city in
            (distance: place.distance(from: city.location), identifier: city.identifier)
        }).min(by: { $0.distance < $1.distance }),
            nearest.distance <= 100_000 else { return nearbyFallbackTimeZone }
        return TimeZone(identifier: nearest.identifier) ?? nearbyFallbackTimeZone
    }
}
