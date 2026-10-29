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
    init(reviewee: Reviewee, meeting: ReviewMeetingInfo) {
        self.init(
            id: reviewee.userID,
            meetingId: meeting.meetingId,
            revieweeUserId: reviewee.userID,
            profileImageUrl: reviewee.profileImageURL,
            name: reviewee.nickname.displayNickname,
            information: Self.makeInformation(cityName: meeting.cityName, dateText: reviewee.meetingDisplayDate)
        )
    }

    static func makeInformation(cityName: String?, dateText: String) -> String {
        [cityName, dateText]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: " · ")
    }
}

extension Reviewee {
    var meetingDisplayDate: String {
        meetingDate?.toFormattedString("yyyy년 M월 d일") ?? ""
    }
}
