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
        type: NearbyUserType
    ) -> MatchingScheduleDetailDisplayData {
        return MatchingScheduleDetailDisplayData(
            cardItem: cardItem,
            placeName: schedule.place.name,
            placeAddress: schedule.place.address,
            latitude: schedule.place.latitude,
            longitude: schedule.place.longitude,
            scheduledAtText: schedule.scheduledAt,
            openChatUrl: openChatUrl,
            type: type
        )
    }
}
