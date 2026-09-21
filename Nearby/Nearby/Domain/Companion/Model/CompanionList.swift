//
//  CompanionList.swift
//  Nearby
//
//  Created by soomin on 9/21/26.
//

import Foundation

struct CompanionList {
    let summaryText: String
    let posts: [CompanionPost]
}

struct CompanionSearchCriteria {
    let latitude: Double
    let longitude: Double
    let radiusMeters: Int
    let placeCategory: CompanionPlace.Category
    let sort: Sort
}

extension CompanionSearchCriteria {
    enum Sort {
        case latest
        case nearest
        case closingSoon
    }
}

struct CompanionPost {
    let postId: Int
    let host: CompanionHost
    let place: CompanionPlace
    let contentPreview: String
    let meetingTimeType: CompanionMeetingTimeType
    let meetingAt: Date?
    let meetingAtText: String?
    let participantCount: Int
    let participants: [CompanionParticipant]
    let participantSummaryText: String
    let createdAt: Date?
    let createdAgoText: String
}

struct CompanionHost {
    let nickname: String
    let gender: Gender
}

struct CompanionPlace {
    let placeId: Int
    let googlePlaceId: String
    let name: String
    let category: Category
    let latitude: Double
    let longitude: Double
    let distanceMeters: Int
    let imageURL: URL?
    let usesDefaultImage: Bool
}

struct CompanionParticipant {
    let userId: Int
    let profileImageURL: String?
}

enum CompanionMeetingTimeType {
    case now
    case scheduled
    case undecided
    case unknown
}

extension CompanionHost {
    enum Gender {
        case female
        case male
        case unknown
    }
}

extension CompanionPlace {
    enum Category: Equatable {
        case restaurant
        case cafe
        case pub
        case museum
        case photoSpot
        case unknown
    }
}
