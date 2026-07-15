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
    init(dto: CompanionDTO) {
        self.init(
            placeImage: nil,
            placeImageURL: dto.place.imageSource == "DEFAULT"
                ? nil
                : URL(string: dto.place.imageUrl),
            placeName: dto.place.name,
            writtenTime: dto.createdAgoText,
            content: dto.contentPreview,
            schedule: dto.nearMeetingTimeTitle,
            participantImageURLs: dto.participantProfileImageURLs,
            statusText: dto.participantSummaryText,
            detailState: CompanionDetailState(
                postId: dto.postId,
                postType: .scheduled,
                isApplicationEnabled: false,
                tags: [],
                hostName: dto.host.nickname,
                genderTitle: dto.host.gender == "FEMALE" ? "여성" : "남성",
                profileImageURL: dto.participants.first?.profileImageUrl.flatMap(URL.init(string:)),
                placeName: dto.place.name,
                googlePlaceId: dto.place.googlePlaceId,
                placeLatitude: dto.place.latitude,
                placeLongitude: dto.place.longitude,
                meetingTimeText: dto.nearMeetingTimeTitle,
                participantSummaryText: dto.participantSummaryText,
                participantCount: dto.participantCount,
                participantImageURLs: dto.participantProfileImageURLs,
                content: dto.contentPreview
            )
        )
    }
}

extension CompanionDTO {
    var participantProfileImageURLs: [String?] {
        let imageURLs = participants.map(\.profileImageUrl)
        let missingCount = max(participantCount - imageURLs.count, 0)
        return imageURLs + [String?](repeating: nil, count: missingCount)
    }
}
