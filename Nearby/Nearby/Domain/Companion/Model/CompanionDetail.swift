//
//  CompanionDetail.swift
//  Nearby
//
//  Created by soomin on 9/21/26.
//

import Foundation

struct CompanionDetail {
    let postId: Int
    let hostUserId: Int
    let hostProfileId: Int
    let googlePlaceId: String
    let meetingAt: Date?
    let maxParticipants: Int
    let content: String
    let isRecruiting: Bool
    let meetingTimeType: CompanionMeetingTimeType
    let expiresAt: Date?
    let participantCount: Int
    let participants: [CompanionParticipant]
    let hasNotApplied: Bool
    let hostProfile: CompanionHostProfile
}

struct CompanionHostProfile {
    let nickname: String
    let gender: CompanionHost.Gender
    let profileImageURL: URL?
    let introduction: String?
    let mannerScore: Double
    let isPhoneVerified: Bool
    let keywords: [String]
}
