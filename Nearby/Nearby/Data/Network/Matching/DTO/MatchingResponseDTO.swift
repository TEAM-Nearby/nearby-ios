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
    let members: [Member]
    let companionPost: CompanionPost

    struct Member: Decodable {
        let memberId: Int
        let profileImageUrl: String?
        let nickname: String
    }

    struct CompanionPost: Decodable {
        let postId: Int
        let content: String
        let meetingTimeType: MeetingTimeType
        let meetingAt: String
    }
}
