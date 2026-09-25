//
//  SpecificCompanionCellItem.swift
//  Nearby
//
//  Created by soomin on 7/9/26.
//

import UIKit

struct SpecificCompanionCellItem {
    let placeImageURL: URL?
    let placeName: String
    let placeInfo: String
    let profileImageURL: String?
    let hostName: String
    let genderTitle: String
    let writtenTime: String
    let content: String
    let meetingTime: String
    let closedTime: String
    let participantImageURLs: [String?]
    let statusText: String
    let detailState: CompanionDetailState
}

extension SpecificCompanionCellItem {
    init(post: CompanionPost) {
        let distanceTitle = post.place.distanceMeters < 1_000 ? "\(post.place.distanceMeters)m" : String(format: "%.1fkm", Double(post.place.distanceMeters) / 1_000)

        self.init(
            placeImageURL: post.place.usesDefaultImage ? nil : post.place.imageURL,
            placeName: post.place.name,
            placeInfo: "\(post.place.category.title) · \(distanceTitle)",
            profileImageURL: post.participants.first?.profileImageURL,
            hostName: post.host.nickname,
            genderTitle: post.host.gender.title,
            writtenTime: post.createdAgoDisplayText,
            content: post.contentPreview,
            meetingTime: post.specificMeetingTimeTitle,
            closedTime: post.closingTimeTitle,
            participantImageURLs: post.participantProfileImageURLs,
            statusText: post.participantSummaryText,
            detailState: CompanionDetailState(
                postId: post.postId,
                postType: post.meetingTimeType == .now ? .immediate(expirationTime: "곧") : .scheduled,
                isApplicationEnabled: false,
                tags: [],
                hostName: post.host.nickname,
                genderTitle: post.host.gender.title,
                profileImageURL: post.participants.first?.profileImageURL.flatMap(URL.init(string:)),
                placeName: post.place.name,
                googlePlaceId: post.place.googlePlaceId,
                placeLatitude: post.place.latitude,
                placeLongitude: post.place.longitude,
                meetingTimeText: post.specificMeetingTimeTitle,
                participantSummaryText: post.participantSummaryText,
                participantCount: post.participantCount,
                participantImageURLs: post.participantProfileImageURLs,
                content: post.contentPreview
            )
        )
    }
}
