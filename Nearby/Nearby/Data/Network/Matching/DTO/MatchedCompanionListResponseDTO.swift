//
//  MatchedCompanionListResponseDTO.swift
//  Nearby
//
//  Created by 장지인 on 7/13/26.
//

import Foundation

struct MatchedCompanionListResponseDTO: Decodable {
    let matches: [Match]

    struct Match: Decodable {
        let matchId: Int
        let hostNickname: String
        let hostProfileImageUrl: String?
        let hostGender: HostGender
        let placeName: String?
        let meetingAt: String?
        let meetingTimeType: MeetingTimeType
        let createdAt: String
        let content: String
        let matchStatus: MatchStatus
    }
}

enum HostGender: String, Decodable {
    case male = "MALE"
    case female = "FEMALE"
}

enum MatchStatus: String, Decodable {
    case matched = "MATCHED"
    case scheduleConfirmed = "SCHEDULE_CONFIRMED"
}

struct MatchMyScheduleResponseDTO: Decodable {
    let matchId: Int64
    let matchStatus: MatchStatus
    let schedule: Schedule?
    let openChatUrl: String?
    let userNickname: String?
    let meetingTimeType: MeetingTimeType

    struct Schedule: Decodable {
        let place: Place
        let scheduledAt: String
    }

    struct Place: Decodable {
        let googlePlaceId: String
        let name: String
        let address: String
        let latitude: Double
        let longitude: Double
    }
}
