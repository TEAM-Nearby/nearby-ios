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

struct MatchedCompanionPreviewResponseDTO: Decodable {
    let matchId: Int
    let host: Host
    let members: [Member]
    let companionPost: CompanionPost

    struct Host: Decodable {
        let hostName: String
        let hostProfileImageUrl: String?
    }

    struct Member: Decodable {
        let memberId: Int
        let profileImageUrl: String?
        let nickname: String
    }

    struct CompanionPost: Decodable {
        let postId: Int
        let content: String
        let placeName: String
        let meetingTimeType: MeetingTimeType
        let meetingAt: String?
    }
}

struct MatchMyScheduleResponseDTO: Decodable {
    let matchId: Int
    let matchStatus: MatchStatus
    let schedule: Schedule?
    let openChatUrl: String?
    let userNickname: String?
    let meetingTimeType: MeetingTimeType
    let currentUserRole: NearbyUserType

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

struct ConfirmCompanionScheduleRequestDTO {
    let scheduledAt: String
}

struct ConfirmCompanionScheduleResponseDTO: Decodable {
    let matchId: Int
    let scheduleId: Int
    let matchStatus: MatchStatus
}
