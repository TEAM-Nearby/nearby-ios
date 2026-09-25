//
//  CompanionPostFormatting.swift
//  Nearby
//
//  Created by soomin on 9/21/26.
//

import Foundation

extension CompanionPost {
    var nearMeetingTimeTitle: String {
        meetingTimeTitle(hourDateFormat: "M월 d일 a h시", minuteDateFormat: "M월 d일 a h시 m분")
    }

    var specificMeetingTimeTitle: String {
        meetingTimeTitle(hourDateFormat: "a h시", minuteDateFormat: "a h시 m분")
    }

    var closingTimeTitle: String {
        guard meetingTimeType == .scheduled, let meetingAt else { return "" }

        let remainingTime = meetingAt.timeIntervalSinceNow
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
        guard let createdAt else { return createdAgoText }

        let elapsedTime = Date().timeIntervalSince(createdAt)
        guard elapsedTime >= 86_400 else { return createdAgoText }

        return "\(Int(elapsedTime / 86_400))일 전"
    }

    var participantProfileImageURLs: [String?] {
        let imageURLs = participants.map(\.profileImageURL)
        let missingCount = max(participantCount - imageURLs.count, 0)
        return imageURLs + [String?](repeating: nil, count: missingCount)
    }
}

extension CompanionHost.Gender {
    var title: String {
        switch self {
        case .female: "여성"
        case .male: "남성"
        case .unknown: ""
        }
    }
}

extension CompanionPlace.Category {
    var title: String {
        switch self {
        case .restaurant: "식당"
        case .cafe: "카페"
        case .pub: "펍"
        case .museum: "박물관"
        case .photoSpot: "사진 명소"
        case .unknown: "기타"
        }
    }
}

private extension CompanionPost {
    func meetingTimeTitle(hourDateFormat: String, minuteDateFormat: String) -> String {
        switch meetingTimeType {
        case .now:
            return "지금 바로"
        case .undecided:
            return "시간 미정"
        case .scheduled, .unknown:
            guard let meetingAt else { return meetingAtText ?? "" }

            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.timeZone = .current
            formatter.dateFormat = Calendar.current.component(.minute, from: meetingAt) == 0
                ? hourDateFormat
                : minuteDateFormat
            return formatter.string(from: meetingAt)
        }
    }
}
