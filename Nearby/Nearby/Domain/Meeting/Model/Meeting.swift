//
//  Meeting.swift
//  Nearby
//
//  Created by h2e on 9/26/26.
//

import Foundation

struct Meeting {
    let meetingID: Int?
    let matchID: Int
    let companion: Companion
    let placeName: String
    let meetingAt: Date?
    let meetingTimeType: PostType
    let isCheckedIn: Bool
    
    struct Companion {
        let userID: Int
        let nickname: String
        let gender: NearbyGender
        let profileImageURL: String?
    }
}

struct MeetingDetail {
    let meetingID: Int
    let currentUserRole: NearbyUserType
    let hostNickname: String
    let hostGender: NearbyGender
    let hostProfileImageURL: String?
    let placeName: String
    let meetingAt: Date?
    let meetingTimeType: PostType
    let isCurrentUserCheckedIn: Bool
    let meetingStatus: MeetingStatus
}
