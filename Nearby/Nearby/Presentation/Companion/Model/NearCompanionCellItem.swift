//
//  NearCompanionCellItem.swift
//  Nearby
//
//  Created by soomin on 7/9/26.
//

import UIKit

struct NearCompanionCellItem {
    let placeImage: UIImage?
    let placeImageURL: URL?
    let placeName: String
    let writtenTime: String
    let content: String
    let schedule: String
    let participantImageURLs: [String?]
    let statusText: String
    let detailState: CompanionDetailState
}

extension NearCompanionCellItem {
    init(post: CompanionPost) {
        self.init(
            placeImage: nil,
            placeImageURL: post.place.usesDefaultImage ? nil : post.place.imageURL,
            placeName: post.place.name,
            writtenTime: post.createdAgoDisplayText,
            content: post.contentPreview,
            schedule: post.nearMeetingTimeTitle,
            participantImageURLs: post.participantProfileImageURLs,
            statusText: post.participantSummaryText,
            detailState: CompanionDetailState(
                postId: post.postID,
                postType: .scheduled,
                isApplicationEnabled: false,
                tags: [],
                hostName: post.host.nickname,
                genderTitle: post.host.gender.title,
                profileImageURL: post.participants.first?.profileImageURL.flatMap(URL.init(string:)),
                placeName: post.place.name,
                googlePlaceId: post.place.googlePlaceID,
                placeLatitude: post.place.latitude,
                placeLongitude: post.place.longitude,
                meetingTimeText: post.nearMeetingTimeTitle,
                participantSummaryText: post.participantSummaryText,
                participantCount: post.participantCount,
                participantImageURLs: post.participantProfileImageURLs,
                content: post.contentPreview
            )
        )
    }
}
