//
//  CompanionResponseDTO.swift
//  Nearby
//
//  Created by soomin on 7/13/26.
//

import Foundation

struct CompanionListResponseDTO: Decodable {
    let currentLocation: CompanionLocationDTO
    let radiusMeters: Int
    let maxRadiusMeters: Int
    let placeCategory: String
    let sort: String
    let totalCount: Int
    let summaryText: String
    let posts: [CompanionDTO]
}

struct CompanionLocationDTO: Decodable {
    let latitude: Double
    let longitude: Double
}

struct CompanionDTO: Decodable {
    let postId: Int
    let status: String
    let host: CompanionHostDTO
    let place: CompanionPlaceDTO
    let contentPreview: String
    let contentPreviewTruncated: Bool
    let meetingAt: String
    let meetingAtText: String
    let participantCount: Int
    let maxParticipants: Int
    let participantSummaryText: String
    let createdAt: String
    let createdAgoText: String
    let mapMarkerText: String
}

struct CompanionHostDTO: Decodable {
    let nickname: String
    let gender: String
}

struct CompanionPlaceDTO: Decodable {
    let placeId: Int
    let googlePlaceId: String
    let name: String
    let category: String
    let latitude: Double
    let longitude: Double
    let distanceMeters: Int
    let imageUrl: String
    let imageSource: String
}
