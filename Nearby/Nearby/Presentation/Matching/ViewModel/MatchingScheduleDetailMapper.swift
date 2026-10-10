//
//  MatchingScheduleDetailMapper.swift
//  Nearby
//
//  Created by 장지인 on 9/21/26.
//

import Foundation

enum MatchingScheduleDetailMapper {
    static func map(scheduleDetail: MatchedCompanionScheduleDetail, preview: MatchedCompanionPreview?) -> MatchingScheduleDetailDisplayData {
        let userType = makeUserType(scheduleDetail.currentUserRole)
        let cardItem = makeCardItem(scheduleDetail: scheduleDetail, preview: preview, userType: userType)

        return MatchingScheduleDetailDisplayData(
            cardItem: cardItem,
            placeName: scheduleDetail.schedule?.place.name ?? "",
            placeAddress: scheduleDetail.schedule?.place.address ?? "",
            googlePlaceId: scheduleDetail.schedule?.place.googlePlaceID,
            latitude: scheduleDetail.schedule?.place.latitude ?? 0,
            longitude: scheduleDetail.schedule?.place.longitude ?? 0,
            scheduledAt: scheduleDetail.schedule?.scheduledAt,
            timeZoneID: scheduleDetail.timeZoneID,
            scheduledAtText: makeDateTimeText(scheduleDetail.schedule?.scheduledAt, timeZoneID: scheduleDetail.timeZoneID, fallback: scheduleDetail.meetingTimeType),
            openChatUrl: scheduleDetail.openChatURL ?? "",
            type: userType
        )
    }
}

private extension MatchingScheduleDetailMapper {
    static func makeCardItem(scheduleDetail: MatchedCompanionScheduleDetail, preview: MatchedCompanionPreview?, userType: NearbyUserType) -> MatchingMatchedCardItem {
        guard let preview else {
            return MatchingMatchedCardItem(
                matchId: scheduleDetail.matchID,
                content: MatchingMatchedCardContentModel(
                    name: scheduleDetail.userNickname ?? "",
                    participantCount: 1,
                    gender: "",
                    uploadedTime: "",
                    place: scheduleDetail.schedule?.place.name ?? "",
                    meetingTime: makeTimeText(scheduleDetail.schedule?.scheduledAt, timeZoneID: scheduleDetail.timeZoneID, fallback: scheduleDetail.meetingTimeType),
                    description: ""
                ),
                matchStatus: scheduleDetail.matchStatus.rawValue,
                type: userType
            )
        }

        let placeName = preview.companionPost.placeName.isEmpty ? scheduleDetail.schedule?.place.name ?? "" : preview.companionPost.placeName

        return MatchingMatchedCardItem(
            matchId: preview.matchID,
            content: MatchingMatchedCardContentModel(
                profileImageUrl: preview.host.hostProfileImageURL,
                profileImageUrls: [preview.host.hostProfileImageURL] + preview.members.map(\.profileImageURL),
                name: preview.host.hostName,
                participantCount: preview.members.count + 1,
                gender: "",
                uploadedTime: "",
                place: placeName,
                meetingTime: makeTimeText(preview.companionPost.meetingAt, timeZoneID: preview.companionPost.timeZoneID, fallback: preview.companionPost.meetingTimeType),
                description: preview.companionPost.content
            ),
            matchStatus: scheduleDetail.matchStatus.rawValue,
            type: userType
        )
    }

    static func makeUserType(_ role: MatchedCompanionUserRole) -> NearbyUserType {
        switch role {
        case .host:
            return .host
        case .participant:
            return .participant
        }
    }

    static func makeTimeText(_ scheduledAt: String?, timeZoneID: String?, fallback timeType: MatchedCompanionTimeType) -> String {
        guard let scheduledAt else { return makeTimeTypeTitle(timeType) }
        guard let date = NearbyDateParser.parseLocal(scheduledAt, timeZoneID: timeZoneID) else {
            return scheduledAt
        }
        return format(date, timeZoneID: timeZoneID, hourFormat: "a h시", minuteFormat: "a h시 m분")
    }

    static func makeDateTimeText(_ scheduledAt: String?, timeZoneID: String?, fallback timeType: MatchedCompanionTimeType) -> String {
        guard let scheduledAt else { return makeTimeTypeTitle(timeType) }
        guard let date = NearbyDateParser.parseLocal(scheduledAt, timeZoneID: timeZoneID) else {
            return scheduledAt
        }
        return format(date, timeZoneID: timeZoneID, hourFormat: "M월 d일 (E) a h시", minuteFormat: "M월 d일 (E) a h시 m분")
    }

    static func format(_ date: Date, timeZoneID: String?, hourFormat: String, minuteFormat: String) -> String {
        let timeZone = timeZoneID.flatMap(TimeZone.init(identifier:)) ?? .nearbyAPITimeZone
        let minute = Calendar(identifier: .gregorian).dateComponents(in: timeZone, from: date).minute
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = timeZone
        formatter.dateFormat = minute == 0 ? hourFormat : minuteFormat
        return formatter.string(from: date)
    }

    static func makeTimeTypeTitle(_ timeType: MatchedCompanionTimeType) -> String {
        switch timeType {
        case .now:
            return "지금 바로"
        case .scheduled:
            return ""
        case .undecided:
            return "시간 미정"
        }
    }
}
