//
//  CompanionDTO+MeetingTime.swift
//  Nearby
//
//  Created by soomin on 7/13/26.
//

import Foundation

extension CompanionDTO {
    var nearMeetingTimeTitle: String {
        meetingTimeTitle(
            hourDateFormat: "M월 d일 a h시",
            minuteDateFormat: "M월 d일 a h시 m분"
        )
    }

    var specificMeetingTimeTitle: String {
        meetingTimeTitle(
            hourDateFormat: "a h시",
            minuteDateFormat: "a h시 m분"
        )
    }

    var closingTimeTitle: String {
        guard meetingTimeType == "SCHEDULED", let meetingDate else { return "" }

        let remainingTime = meetingDate.timeIntervalSinceNow
        guard remainingTime > 0 else { return "" }

        let minute = max(1, Int(ceil(remainingTime / 60)))
        if minute < 60 {
            return " | 마감 \(minute)분 전"
        }

        let hour = Int(ceil(remainingTime / 3_600))
        if hour < 24 {
            return " | 마감 \(hour)시간 전"
        }

        let day = Int(ceil(remainingTime / 86_400))
        return " | 마감 \(day)일 전"
    }

    var createdAgoDisplayText: String {
        guard let createdDate = parsedDate(from: createdAt) else { return createdAgoText }

        let elapsedTime = Date().timeIntervalSince(createdDate)
        guard elapsedTime >= 86_400 else { return createdAgoText }

        return "\(Int(elapsedTime / 86_400))일 전"
    }
}

private extension CompanionDTO {
    func meetingTimeTitle(hourDateFormat: String, minuteDateFormat: String) -> String {
        switch meetingTimeType {
        case "NOW":
            return "지금 바로"
        case "UNDECIDED":
            return "시간 미정"
        default:
            guard let meetingDate else { return meetingAtText ?? "" }

            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.timeZone = .current
            formatter.dateFormat = Calendar.current.component(.minute, from: meetingDate) == 0
                ? hourDateFormat
                : minuteDateFormat
            return formatter.string(from: meetingDate)
        }
    }

    var meetingDate: Date? {
        guard let meetingAt else { return nil }

        return parsedDate(from: meetingAt)
    }

    func parsedDate(from value: String) -> Date? {

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: value) {
            return date
        }

        isoFormatter.formatOptions = [.withInternetDateTime]
        if let date = isoFormatter.date(from: value) {
            return date
        }

        let localFormatter = DateFormatter()
        localFormatter.locale = Locale(identifier: "en_US_POSIX")
        localFormatter.timeZone = .current

        let dateFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm"
        ]

        for dateFormat in dateFormats {
            localFormatter.dateFormat = dateFormat
            if let date = localFormatter.date(from: value) {
                return date
            }
        }

        return nil
    }
}
