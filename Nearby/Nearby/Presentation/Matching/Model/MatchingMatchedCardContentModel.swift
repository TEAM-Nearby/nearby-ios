//
//  MatchingMatchedCardContentModel.swift
//  Nearby
//
//  Created by 장지인 on 7/9/26.
//

import UIKit

struct MatchingMatchedCardContentModel {
    // TODO: - 아바타 스택뷰로 변경
    let profileImage: UIImage?
    let name: String
    let participantCount: Int
    let gender: String
    let uploadedTime: String
    let place: String
    let meetingTime: String
    let description: String
}

struct MatchingMatchedCardItem {
    let content: MatchingMatchedCardContentModel
    let state: MatchingMatchedCardState
    let isHost: Bool
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
        state: .pending,
        isHost: true
    )
}
