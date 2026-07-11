//
//  MatchingMatchSummaryModel.swift
//  Nearby
//
//  Created by 장지인 on 7/12/26.
//

import Foundation

struct MatchingMatchSummaryModel: Decodable {
    let matchId: Int
    let hostNickname: String
    let hostProfileImageUrl: String?
    let hostGender: String
    let placeName: String
    let meetingAt: String?
    let meetingTimeType: String
    let createdAt: String
    let content: String
    let matchStatus: String
}

extension MatchingMatchSummaryModel {
    func toMatchedCardItem(isHost: Bool = false) -> MatchingMatchedCardItem {
        return MatchingMatchedCardItem(
            matchId: matchId,
            content: MatchingMatchedCardContentModel(
                profileImageUrl: hostProfileImageUrl,
                name: hostNickname,
                participantCount: 1,
                gender: hostGender,
                uploadedTime: createdAt,
                place: placeName,
                meetingTime: meetingAt ?? meetingTimeType,
                description: content
            ),
            matchStatus: matchStatus,
            isHost: isHost
        )
    }
}
