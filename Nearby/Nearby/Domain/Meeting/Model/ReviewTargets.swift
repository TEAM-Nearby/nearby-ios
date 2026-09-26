//
//  ReviewTargets.swift
//  Nearby
//
//  Created by h2e on 9/26/26.
//

import Foundation

struct ReviewTargets {
    let currentUserRole: NearbyUserType
    let canCompleteMeeting: Bool
    let reviewees: [Reviewee]
}

struct Reviewee {
    let userID: Int
    let nickname: String
    let profileImageURL: String?
    let cityName: String
    let meetingDate: Date?
    let isCheckedIn: Bool
    let hasWrittenReview: Bool
}
