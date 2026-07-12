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
    let meetingTimeType: String
    let isCheckedIn: Bool
    let meetingStatus: String
    
    struct Companion: Decodable {
        let userId: Int
        let profileImageUrl: String?
        let nickname: String
        let gender: NearbyGender
    }
}
