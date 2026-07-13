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
    let meetingAt: String?
    let maxParticipants: Int
    let content: String
    let openChatUrl: String?
    let status: String
    let createdAt: String
    let meetingTimeType: String
    let expiresAt: String?
    let participantCount: Int
    let applyStatus: String
    let hostProfileSummary: CompanionHostProfileSummaryDTO
}

struct CompanionHostProfileSummaryDTO: Decodable {
    let profileId: Int
    let nickname: String
    let gender: String
    let birthYear: Int?
    let profileImageUrl: String?
    let mannerScore: Double
    let phoneVerifiedAt: String?
    let keywords: [String]
}

struct CompanionApplyResponseDTO: Decodable {
    let applicationId: Int
    let postId: Int
    let applicationStatus: String
    let createdAt: String
}
