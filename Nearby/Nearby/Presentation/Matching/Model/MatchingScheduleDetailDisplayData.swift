//
//  MatchingScheduleDetailDisplayData.swift
//  Nearby
//
//  Created by 장지인 on 7/12/26.
//

import Foundation

struct MatchingScheduleDetailDisplayData {
    let cardItem: MatchingMatchedCardItem
    let placeName: String
    let placeAddress: String
    let googlePlaceId: String?
    let latitude: Double
    let longitude: Double
    let scheduledAtText: String
    let openChatUrl: String
    let type: NearbyUserType
}
