//
//  MatchingScheduleDetailResponseModel.swift
//  Nearby
//
//  Created by 장지인 on 7/12/26.
//

import Foundation

struct MatchingScheduleDetailResponseModel: Decodable {
    let matchId: Int
    let matchStatus: String
    let schedule: MatchingScheduleModel
    let openChatUrl: String
    let userNickname: String
    let meetingTimeType: String
}

extension MatchingScheduleDetailResponseModel {
    func toDisplayData(type: NearbyUserType) -> MatchingScheduleDetailDisplayData {
        let cardItem = MatchingMatchedCardItem(
            matchId: matchId,
            content: MatchingMatchedCardContentModel(
                name: userNickname,
                participantCount: 1,
                gender: "",
                uploadedTime: "",
                place: schedule.place.name,
                meetingTime: schedule.scheduledAt.matchingDetailTimeTitle,
                description: ""
            ),
            matchStatus: matchStatus,
            type: type
        )

        return MatchingScheduleDetailDisplayData(
            cardItem: cardItem,
            placeName: schedule.place.name,
            placeAddress: schedule.place.address,
            googlePlaceId: schedule.place.googlePlaceId,
            latitude: schedule.place.latitude,
            longitude: schedule.place.longitude,
            scheduledAt: schedule.scheduledAt,
            scheduledAtText: schedule.scheduledAt.matchingDetailDateTimeTitle,
            openChatUrl: openChatUrl,
            type: type
        )
    }
}

extension MatchedCompanionPreview {
    func toCardItem(type: NearbyUserType, matchStatus: String, fallbackPlaceName: String) -> MatchingMatchedCardItem {
        let placeName = companionPost.placeName.isEmpty
            ? fallbackPlaceName
            : companionPost.placeName
        let meetingTime = companionPost.meetingAt?.matchingDetailTimeTitle
            ?? companionPost.meetingTimeType.displayTitle

        return MatchingMatchedCardItem(
            matchId: Int(matchID),
            content: MatchingMatchedCardContentModel(
                profileImageUrl: host.hostProfileImageURL, profileImageUrls: [host.hostProfileImageURL] + members.map(\.profileImageURL),
                name: host.hostName, participantCount: members.count + 1, gender: "",
                uploadedTime: "", place: placeName, meetingTime: meetingTime,
                description: companionPost.content
            ),
            matchStatus: matchStatus, type: type
        )
    }
}

extension MatchedCompanionScheduleDetail {
    func toCardItem(type: NearbyUserType) -> MatchingMatchedCardItem {
        MatchingMatchedCardItem(
            matchId: Int(matchID),
            content: MatchingMatchedCardContentModel(
                name: userNickname ?? "",
                participantCount: 1,
                gender: "",
                uploadedTime: "",
                place: schedule?.place.name ?? "",
                meetingTime: schedule?.scheduledAt.matchingDetailTimeTitle
                    ?? meetingTimeType.displayTitle,
                description: ""
            ),
            matchStatus: matchStatus.rawValue,
            type: type
        )
    }

    func toDisplayData(
        type: NearbyUserType,
        cardItem: MatchingMatchedCardItem
    ) -> MatchingScheduleDetailDisplayData {
        return MatchingScheduleDetailDisplayData(
            cardItem: cardItem,
            placeName: schedule?.place.name ?? "",
            placeAddress: schedule?.place.address ?? "",
            googlePlaceId: schedule?.place.googlePlaceID,
            latitude: schedule?.place.latitude ?? 0,
            longitude: schedule?.place.longitude ?? 0,
            scheduledAt: schedule?.scheduledAt,
            scheduledAtText: schedule?.scheduledAt.matchingDetailDateTimeTitle
                ?? meetingTimeType.displayTitle,
            openChatUrl: openChatURL ?? "",
            type: type
        )
    }
}

private extension MatchedCompanionTimeType {
    var displayTitle: String {
        switch self {
        case .now:
            return "지금 바로"
        case .scheduled:
            return ""
        case .undecided:
            return "시간 미정"
        }
    }
}

extension MatchedCompanionUserRole {
    var nearbyUserType: NearbyUserType {
        switch self {
        case .host:
            return .host
        case .participant:
            return .participant
        }
    }
}

private extension String {
    var matchingDetailTimeTitle: String {
        guard let date = isoDate else { return self }
        return date.timeDisplayText
    }

    var matchingDetailDateTimeTitle: String {
        guard let date = isoDate else { return self }
        return date.meetingDisplayText
    }

    var isoDate: Date? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: self) {
            return date
        }

        isoFormatter.formatOptions = [.withInternetDateTime]
        if let date = isoFormatter.date(from: self) {
            return date
        }

        let localFormatter = DateFormatter()
        localFormatter.locale = Locale(identifier: "en_US_POSIX")
        localFormatter.timeZone = .nearbyAPITimeZone

        let dateFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm"
        ]

        for dateFormat in dateFormats {
            localFormatter.dateFormat = dateFormat
            if let date = localFormatter.date(from: self) {
                return date
            }
        }

        return nil
    }
}
