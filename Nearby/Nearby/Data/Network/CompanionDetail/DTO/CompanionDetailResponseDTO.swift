//
//  CompanionDetailResponseDTO.swift
//  Nearby
//
//  Created by soomin on 7/13/26.
//

import Foundation

struct CompanionDetailResponseDTO: Decodable {
    let postId: Int
    let hostUserId: Int
    let hostProfileId: Int
    let googlePlaceId: String
    let city: String?
    let timeZoneID: String?
    let currentLocalTime: String?
    let meetingAt: String?
    let maxParticipants: Int
    let content: String
    let openChatUrl: String?
    let status: String
    let createdAt: String
    let meetingTimeType: String
    let expiresAt: String?
    let participantCount: Int
    let participants: [CompanionParticipantDTO]
    let applyStatus: String
    let hostProfileSummary: CompanionHostProfileSummaryDTO

    enum CodingKeys: String, CodingKey {
        case postId
        case hostUserId
        case hostProfileId
        case googlePlaceId
        case city
        case timeZoneID = "timeZoneId"
        case currentLocalTime
        case meetingAt
        case maxParticipants
        case content
        case openChatUrl
        case status
        case createdAt
        case meetingTimeType
        case expiresAt
        case participantCount
        case participants
        case applyStatus
        case hostProfileSummary
    }
}

struct CompanionHostProfileSummaryDTO: Decodable {
    let profileId: Int
    let nickname: String
    let gender: String
    let birthYear: Int?
    let profileImageUrl: String?
    let intro: String?
    let mannerScore: Double
    let mannerKeywords: [String]
    let phoneVerifiedAt: String?
    let keywords: [String]
}

struct CompanionApplyResponseDTO: Decodable {
    let applicationId: Int
    let postId: Int
    let applicationStatus: String
    let createdAt: String
}
