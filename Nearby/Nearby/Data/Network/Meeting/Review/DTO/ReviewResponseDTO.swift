//
//  ReviewResponseDTO.swift
//  Nearby
//
//  Created by h2e on 7/14/26.
//

struct CreateReviewResponseDTO: Decodable {
    let meetingId: Int
    let reviewId: Int
    let meetingStatus: String
}

struct ReviewTargetsResponseDTO: Decodable {
    let meetingStatus: String
    let currentUserRole: NearbyUserType
    let canCompleteMeeting: Bool
    let reviewTargets: [ReviewTargetDTO]
}

struct ReviewTargetDTO: Decodable {
    let revieweeUserId: Int
    let profileImageUrl: String?
    let nickname: String
    let cityName: String
    let meetingDate: String
    let isCheckedIn: Bool
    let hasWrittenReview: Bool
}

struct ReviewCompleteDTO: Decodable {
    let meetingId: Int
    let matchId: Int
    let currentUserCompleted: Bool
    let currentUserCompletedAt: String
    let meetingStatus: MeetingStatus
    let meetingCompletedAt: String?
}
