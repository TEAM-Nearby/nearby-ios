//
//  HostCompanionResponseDTO.swift
//  Nearby
//
//  Created by h2e on 7/12/26.
//

import Foundation

struct HostCompanionDetailResponseDTO: Decodable {
    let applicationId: Int
    let postId: Int
    let applicationStatus: String
    let placeName: String
    let meetingTimeType: PostType
    let meetingAt: String
    let openChatUrl: String?
    let applicantProfile: ApplicantProfile
    let applicantAccount: ApplicantAccount

    struct ApplicantProfile: Decodable {
        let profileId: Int
        let profileImageUrl: String?
        let nickname: String
        let gender: NearbyGender
        let birthYear: Int?
        let mannerScore: Double
    }

    struct ApplicantAccount: Decodable {
        let phoneVerifiedAt: String?
    }
}

struct HostCompanionAllowResponseDTO: Decodable {
    let applicationId: Int
    let postId: Int
    let applicationStatus: String
    let matchId: Int
    let matchStatus: String
}

struct HostCompanionRejectResponseDTO: Decodable {
    let applicationId: Int
    let postId: Int
    let applicationStatus: String
}
