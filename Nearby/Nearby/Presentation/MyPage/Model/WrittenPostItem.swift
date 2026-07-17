//
//  WrittenPostItem.swift
//  Nearby
//
//  Created by 신서연 on 7/11/26.
//

import Foundation

struct WrittenPostItem {

    // MARK: - Properties

    let id: Int
    let cityName: String

    let placeName: String
    let latitude: Double?
    let longitude: Double?
    let placeID: String?

    let meetingDateText: String
    let currentPeopleCount: Int
    let maximumPeopleCount: Int
    let participantImageURLs: [String?]

    let content: String
    let keywords: [String]

    // MARK: - Initializer

    init(
        id: Int,
        cityName: String,
        placeName: String,
        latitude: Double?,
        longitude: Double?,
        placeID: String? = nil,
        meetingDateText: String,
        currentPeopleCount: Int,
        maximumPeopleCount: Int,
        participantImageURLs: [String?],
        content: String,
        keywords: [String]
    ) {
        self.id = id
        self.cityName = cityName
        self.placeName = placeName
        self.latitude = latitude
        self.longitude = longitude
        self.placeID = placeID
        self.meetingDateText = meetingDateText
        self.currentPeopleCount = currentPeopleCount
        self.maximumPeopleCount = maximumPeopleCount
        self.participantImageURLs = participantImageURLs
        self.content = content
        self.keywords = keywords
    }
}

extension WrittenPostItem {
    init(response: MyCompanionPostDTO) {
        let scheduledDate = response.scheduledAt.flatMap(Self.parseScheduledDate)
        let serverImageURLs = [response.hostProfileImageUrl]
            + response.members.map(\.profileImageUrl)
        let missingImageCount = max(
            response.currentParticipants - serverImageURLs.count,
            0
        )
        let participantImageURLs = serverImageURLs
            + [String?](repeating: nil, count: missingImageCount)

        self.init(
            id: response.postId,
            cityName: response.cityName,
            placeName: response.place.name,
            latitude: response.place.latitude,
            longitude: response.place.longitude,
            placeID: response.place.googlePlaceId,
            meetingDateText: scheduledDate.map(Self.meetingDateText) ?? "시간 미정",
            currentPeopleCount: response.currentParticipants,
            maximumPeopleCount: response.maxParticipants,
            participantImageURLs: participantImageURLs,
            content: response.content,
            keywords: MannerKeyword.titles(for: response.reviewKeywords)
        )
    }
}

private extension WrittenPostItem {
    static func parseScheduledDate(_ value: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .nearbyAPITimeZone

        for format in ["yyyy-MM-dd'T'HH:mm:ss.SSSSSS", "yyyy-MM-dd'T'HH:mm:ss"] {
            formatter.dateFormat = format
            if let date = formatter.date(from: value) {
                return date
            }
        }

        return ISO8601DateFormatter.withFractionalSeconds.date(from: value)
            ?? ISO8601DateFormatter.standard.date(from: value)
    }

    static func meetingDateText(_ date: Date) -> String {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        let minute = calendar.component(.minute, from: date)
        let formatString = minute == 0 ? "M월 d일 (E) a h시" : "M월 d일 (E) a h시 m분"
        return formatDate(date, format: formatString)
    }

    static func formatDate(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = .current
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
