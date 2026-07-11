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
    func toDisplayData(
        cardItem: MatchingMatchedCardItem,
        isHost: Bool
    ) -> MatchingScheduleDetailDisplayData {
        return MatchingScheduleDetailDisplayData(
            cardItem: cardItem,
            placeName: schedule.place.name,
            placeAddress: schedule.place.address,
            googlePlaceId: schedule.place.googlePlaceId,
            latitude: schedule.place.latitude,
            longitude: schedule.place.longitude,
            scheduledAtText: schedule.scheduledAt,
            openChatUrl: openChatUrl,
            isHost: isHost
        )
    }
}
