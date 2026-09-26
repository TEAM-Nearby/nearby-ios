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
    init(reviewee: Reviewee, meetingId: Int) {
        self.init(
            id: reviewee.userID,
            meetingId: meetingId,
            revieweeUserId: reviewee.userID,
            profileImageUrl: reviewee.profileImageURL,
            name: reviewee.nickname,
            information: "\(reviewee.cityName) · \(reviewee.meetingDisplayDate)"
        )
    }
}

extension Reviewee {
    var meetingDisplayDate: String {
        meetingDate?.toFormattedString("yyyy년 M월 d일") ?? ""
    }
}
