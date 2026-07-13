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
    let participantImages: [UIImage?]
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
            schedule: dto.meetingAtText,
            participantImages: Array(
                repeating: nil,
                count: max(dto.participantCount, 1)
            ),
            statusText: dto.participantSummaryText,
            detailState: CompanionDetailState(
                postType: .scheduled,
                isApplicationEnabled: dto.status == "RECRUITING",
                tags: []
            )
        )
    }
}
