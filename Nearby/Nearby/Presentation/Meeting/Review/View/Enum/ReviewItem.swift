//
//  ReviewItem.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import Foundation

struct ReviewItem {
    let id: Int
    let meetingId: Int
    let revieweeUserId: Int
    let profileImageUrl: String?
    let name: String
    let information: String
}

extension ReviewItem {
    init(target: ReviewTargetDTO, meetingId: Int) {
        self.init(
            id: target.revieweeUserId,
            meetingId: meetingId,
            revieweeUserId: target.revieweeUserId,
            profileImageUrl: target.profileImageUrl,
            name: target.nickname,
            information: "\(target.cityName) · \(target.meetingDisplayDate)"
        )
    }
}

extension ReviewTargetDTO {
    var meetingDisplayDate: String {
        DateFormatter.cached(format: "yyyy-MM-dd")
            .date(from: meetingDate)?
            .toFormattedString("yyyy년 M월 d일") ?? meetingDate
    }
}
