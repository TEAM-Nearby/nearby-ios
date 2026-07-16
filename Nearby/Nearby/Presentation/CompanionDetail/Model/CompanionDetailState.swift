//
//  CompanionDetailState.swift
//  Nearby
//
//  Created by soomin on 7/10/26.
//

import Foundation

struct CompanionDetailState {
    let postId: Int?
    let hostProfileId: Int?
    let postType: PostType
    let isApplicationEnabled: Bool
    let tags: [String]
    let hostName: String
    let genderTitle: String
    let profileImageURL: URL?
    let hostIntroduction: String?
    let mannerScoreText: String
    let isPhoneVerified: Bool
    let placeName: String
    let googlePlaceId: String?
    let placeLatitude: Double?
    let placeLongitude: Double?
    let meetingTimeText: String
    let participantSummaryText: String
    let participantCount: Int
    let participantImageURLs: [String?]
    let content: String

    init(
        postId: Int? = nil,
        hostProfileId: Int? = nil,
        postType: PostType,
        isApplicationEnabled: Bool,
        tags: [String],
        hostName: String = "",
        genderTitle: String = "",
        profileImageURL: URL? = nil,
        hostIntroduction: String? = nil,
        mannerScoreText: String = "",
        isPhoneVerified: Bool = false,
        placeName: String = "",
        googlePlaceId: String? = nil,
        placeLatitude: Double? = nil,
        placeLongitude: Double? = nil,
        meetingTimeText: String = "",
        participantSummaryText: String = "",
        participantCount: Int = 0,
        participantImageURLs: [String?] = [],
        content: String = ""
    ) {
        self.postId = postId
        self.hostProfileId = hostProfileId
        self.postType = postType
        self.isApplicationEnabled = isApplicationEnabled
        self.tags = tags
        self.hostName = hostName
        self.genderTitle = genderTitle
        self.profileImageURL = profileImageURL
        self.hostIntroduction = hostIntroduction
        self.mannerScoreText = mannerScoreText
        self.isPhoneVerified = isPhoneVerified
        self.placeName = placeName
        self.googlePlaceId = googlePlaceId
        self.placeLatitude = placeLatitude
        self.placeLongitude = placeLongitude
        self.meetingTimeText = meetingTimeText
        self.participantSummaryText = participantSummaryText
        self.participantCount = participantCount
        self.participantImageURLs = participantImageURLs
        self.content = content
    }
}
