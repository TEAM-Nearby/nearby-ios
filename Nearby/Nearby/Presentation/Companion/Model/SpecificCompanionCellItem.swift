//
//  SpecificCompanionCellItem.swift
//  Nearby
//
//  Created by soomin on 7/9/26.
//

import UIKit

struct SpecificCompanionCellItem {
    let profileImage: UIImage?
    let hostName: String
    let genderTitle: String
    let writtenTime: String
    let content: String
    let meetingTime: String
    let closedTime: String
    let participantImages: [UIImage?]
    let statusText: String
    let detailState: CompanionDetailState
}

extension SpecificCompanionCellItem {
    init(dto: CompanionDTO) {
        self.init(
            profileImage: nil,
            hostName: dto.host.nickname,
            genderTitle: dto.host.gender == "FEMALE" ? "여성" : "남성",
            writtenTime: dto.createdAgoText,
            content: dto.contentPreview,
            meetingTime: dto.specificMeetingTimeTitle,
            closedTime: dto.closingTimeTitle,
            participantImages: Array(repeating: nil, count: max(dto.participantCount, 1)),
            statusText: dto.participantSummaryText,
            detailState: CompanionDetailState(
                postId: dto.postId,
                postType: dto.meetingTimeType == "NOW" ? .immediate(expirationTime: "곧") : .scheduled,
                isApplicationEnabled: dto.status == "RECRUITING",
                tags: [],
                hostName: dto.host.nickname,
                genderTitle: dto.host.gender == "FEMALE" ? "여성" : "남성",
                placeName: dto.place.name,
                googlePlaceId: dto.place.googlePlaceId,
                placeLatitude: dto.place.latitude,
                placeLongitude: dto.place.longitude,
                meetingTimeText: dto.specificMeetingTimeTitle,
                participantSummaryText: dto.participantSummaryText,
                participantCount: dto.participantCount,
                content: dto.contentPreview
            )
        )
    }
}
