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
        let scheduledDate = NearbyDateParser.parseLocal(response.scheduledAt, timeZoneID: response.timeZoneId)
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
            cityName: response.cityNameKor ?? response.city ?? "도시 정보 없음",
            placeName: response.place.name,
            latitude: response.place.latitude,
            longitude: response.place.longitude,
            placeID: response.place.googlePlaceId,
            meetingDateText: scheduledDate.map {
                Self.meetingDateText($0, timeZoneID: response.timeZoneId)
            } ?? "시간 미정",
            currentPeopleCount: response.currentParticipants,
            maximumPeopleCount: response.maxParticipants,
            participantImageURLs: participantImageURLs,
            content: response.content,
            keywords: MannerKeyword.titles(for: response.reviewKeywords)
        )
    }
}

private extension WrittenPostItem {
    static func meetingDateText(_ date: Date, timeZoneID: String?) -> String {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZoneID.flatMap(TimeZone.init(identifier:)) ?? .nearbyAPITimeZone
        let minute = calendar.component(.minute, from: date)
        let formatString = minute == 0 ? "M월 d일 (E) a h시" : "M월 d일 (E) a h시 m분"
        return formatDate(date, format: formatString, timeZoneID: timeZoneID)
    }

    static func formatDate(_ date: Date, format: String, timeZoneID: String?) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = timeZoneID.flatMap(TimeZone.init(identifier:)) ?? .nearbyAPITimeZone
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
