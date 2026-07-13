//
//  RecruitCompanionResponseDTO.swift
//  Nearby
//
//  Created by 장지인 on 7/13/26.
//

import Foundation

struct RecruitCompanionResponseDTO: Decodable {
    let postId: Int64
    let status: RecruitCompanionStatus
    let hostUserId: Int64
    let place: Place
    let meetingTimeType: MeetingTimeType
    let meetingAt: String?
    let exposureExpiresAt: String?
    let maxParticipants: Int
    let participantCount: Int
    let departEvenIfNotFull: Bool
    let styleKeywords: [String]
    let content: String
    let openChatUrl: String
    let createdAt: String

    struct Place: Decodable {
        let placeId: Int64
        let googlePlaceId: String
        let name: String
        let address: String
        let latitude: Double
        let longitude: Double
        let category: PlaceCategory
    }
}
