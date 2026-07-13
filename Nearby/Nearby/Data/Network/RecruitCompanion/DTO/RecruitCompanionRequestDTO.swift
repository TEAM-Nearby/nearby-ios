//
//  RecruitCompanionRequestDTO.swift
//  Nearby
//
//  Created by 장지인 on 7/13/26.
//

import Foundation

struct RecruitCompanionRequestDTO: Encodable {
    let place: Place
    let meetingTimeType: MeetingTimeType
    let meetingAt: String?
    let maxParticipants: Int
    let styleKeywords: [RecruitCompanionStyleKeyword]
    let content: String
    let openChatUrl: String

    struct Place: Encodable {
        let googlePlaceId: String
        let name: String
        let address: String
        let latitude: Double
        let longitude: Double
        let category: PlaceCategory
    }
}
