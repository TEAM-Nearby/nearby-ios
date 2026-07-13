//
//  MeetingResponseDTO.swift
//  Nearby
//
//  Created by h2e on 7/13/26.
//

import Foundation

struct MeetingListResponseDTO: Decodable {
    let meetings: [MeetingResponseDTO]
}

struct MeetingResponseDTO: Decodable {
    let meetingId: Int
    let matchId: Int
    let companion: Companion
    let placeName: String
    let meetingAt: String
    let meetingTimeType: PostType
    let isCheckedIn: Bool
    let meetingStatus: String
    
    struct Companion: Decodable {
        let userId: Int
        let profileImageUrl: String?
        let nickname: String
        let gender: NearbyGender
    }
}

struct MeetingDetailResponseDTO: Decodable {
    let meetingId: Int
    let currentUserRole: NearbyUserType
    let hostId: Int
    let hostGender: NearbyGender
    let hostCheckedIn: Bool
    let hostProfileImageUrl: String?
    let hostNickname: String
    let placeName: String
    let meetingAt: String
    let meetingTimeType: PostType
    let currentUserCheckedIn: Bool
    let canCancelMeeting: Bool
    let meetingStatus: String
}

struct MeetingCheckInResponseDTO: Decodable {
    let meetingId: Int
    let meetingStatus: String
    let currentUserCheckedIn: Bool
    let checkedInCount: Int
    let totalParticipantCount: Int
    let allParticipantsCheckedIn: Bool
    let canMoveToComplete: Bool
    let checkedInAt: String
    let distanceMeters: Double
    let allowedRadiusMeters: Double
    let checkInAvailableFrom: String
    let checkInAvailableUntil: String
}
