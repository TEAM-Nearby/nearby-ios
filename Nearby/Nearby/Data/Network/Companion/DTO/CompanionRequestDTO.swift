//
//  CompanionRequestDTO.swift
//  Nearby
//
//  Created by 신서연 on 7/14/26.
//

import Foundation

enum CompanionRequestDirection: String, Decodable {
    case sent = "SENT"
    case received = "RECEIVED"
}

enum CompanionRequestStatus: String, Decodable {
    case pending = "PENDING"
    case accepted = "ACCEPTED"
    case rejected = "REJECTED"
    case canceled = "CANCELED"
}

enum CompanionRequestActionType: String, Decodable {
    case confirmSchedule = "CONFIRM_SCHEDULE"
    case viewRejection = "VIEW_REJECTION"
    case viewResult = "VIEW_RESULT"
    case acceptRequest = "ACCEPT_REQUEST"
    case none = "NONE"
}

struct CompanionRequestListResponseDTO: Decodable {

    // MARK: - Properties

    let direction: CompanionRequestDirection
    let requests: [CompanionRequestDTO]
}

struct CompanionRequestDTO: Decodable {

    // MARK: - Properties

    let notificationId: Int
    let applicationId: Int
    let applicationStatus: CompanionRequestStatus
    let host: CompanionRequestHostDTO
    let placeName: String
    let meetingAt: String
    let matchId: Int?
    let actionType: CompanionRequestActionType
    let isRead: Bool
}

struct CompanionRequestHostDTO: Decodable {

    // MARK: - Properties

    let userId: Int
    let profileImageUrl: String?
    let nickname: String
}

struct CompanionNotificationReadResponseDTO: Decodable {

    // MARK: - Properties

    let notificationId: Int
    let isRead: Bool
    let readAt: String
}
