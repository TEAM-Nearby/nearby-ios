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
    init(dto: CompanionDTO) {
        self.init(
            placeImageURL: dto.place.imageSource == "DEFAULT" ? nil : URL(string: dto.place.imageUrl),
            placeName: dto.place.name,
            placeInfo: "\(dto.place.categoryTitle) · \(dto.place.distanceTitle)",
            profileImageURL: dto.participants.first?.profileImageUrl,
            hostName: dto.host.nickname,
            genderTitle: dto.host.gender == "FEMALE" ? "여성" : "남성",
            writtenTime: dto.createdAgoDisplayText,
            content: dto.contentPreview,
            meetingTime: dto.specificMeetingTimeTitle,
            closedTime: dto.closingTimeTitle,
            participantImageURLs: dto.participantProfileImageURLs,
            statusText: dto.participantSummaryText,
            detailState: CompanionDetailState(
                postId: dto.postId,
                postType: dto.meetingTimeType == "NOW" ? .immediate(expirationTime: "곧") : .scheduled,
                isApplicationEnabled: false,
                tags: [],
                hostName: dto.host.nickname,
                genderTitle: dto.host.gender == "FEMALE" ? "여성" : "남성",
                profileImageURL: dto.participants.first?.profileImageUrl.flatMap(URL.init(string:)),
                placeName: dto.place.name,
                googlePlaceId: dto.place.googlePlaceId,
                placeLatitude: dto.place.latitude,
                placeLongitude: dto.place.longitude,
                meetingTimeText: dto.specificMeetingTimeTitle,
                participantSummaryText: dto.participantSummaryText,
                participantCount: dto.participantCount,
                participantImageURLs: dto.participantProfileImageURLs,
                content: dto.contentPreview
            )
        )
    }
}

private extension CompanionPlaceDTO {
    var categoryTitle: String {
        switch category {
        case "RESTAURANT": return "식당"
        case "CAFE": return "카페"
        case "PUB": return "펍"
        case "MUSEUM": return "박물관"
        case "PHOTO_SPOT": return "사진 명소"
        default: return "기타"
        }
    }

    var distanceTitle: String {
        distanceMeters < 1_000
            ? "\(distanceMeters)m"
            : String(format: "%.1fkm", Double(distanceMeters) / 1_000)
    }
}
