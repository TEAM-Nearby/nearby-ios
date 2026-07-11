//
//  MatchingMatchedCardItem.swift
//  Nearby
//
//  Created by 장지인 on 7/12/26.
//

import UIKit

struct MatchingMatchedCardItem {
    let matchId: Int
    let content: MatchingMatchedCardContentModel
    let matchStatus: String
    let isHost: Bool

    init(
        matchId: Int = 0,
        content: MatchingMatchedCardContentModel,
        matchStatus: String = "",
        isHost: Bool = false
    ) {
        self.matchId = matchId
        self.content = content
        self.matchStatus = matchStatus
        self.isHost = isHost
    }
}

extension MatchingMatchedCardItem {
    static let sample = MatchingMatchedCardItem(
        content: MatchingMatchedCardContentModel(
            profileImage: .imgProfileDefault,
            name: "정지영",
            participantCount: 3,
            gender: "여성",
            uploadedTime: "15분 전 올림",
            place: "시우다드 콘달",
            meetingTime: "오후 4:30",
            description: "오늘 저녁 바르셀로나에서 같이 타파스 드실 분 구해요!"
        ),
        isHost: true
    )
}
