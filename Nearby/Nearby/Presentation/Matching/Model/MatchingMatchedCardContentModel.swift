//
//  MatchingMatchedCardContentModel.swift
//  Nearby
//
//  Created by 장지인 on 7/9/26.
//

import UIKit

struct MatchingMatchedCardContentModel {
    let profileImage: UIImage?
    let profileImageUrl: String?
    let name: String
    let participantCount: Int
    let gender: String
    let uploadedTime: String
    let place: String
    let meetingTime: String
    let description: String

    init(
<<<<<<< HEAD
        profileImage: UIImage? = nil, profileImageUrl: String? = nil, name: String,
        participantCount: Int, gender: String, uploadedTime: String,
        place: String, meetingTime: String, description: String
=======
        profileImage: UIImage? = nil,
        profileImageUrl: String? = nil,
        name: String,
        participantCount: Int,
        gender: String,
        uploadedTime: String,
        place: String,
        meetingTime: String,
        description: String
>>>>>>> origin/feat/#76
    ) {
        self.profileImage = profileImage
        self.profileImageUrl = profileImageUrl
        self.name = name
        self.participantCount = participantCount
        self.gender = gender
        self.uploadedTime = uploadedTime
        self.place = place
        self.meetingTime = meetingTime
        self.description = description
    }
<<<<<<< HEAD
=======
}

struct MatchingMatchedCardItem {
    let matchId: Int
    let content: MatchingMatchedCardContentModel
    let matchStatus: String
    let isHost: Bool

    init(
        matchId: Int = 0,
        content: MatchingMatchedCardContentModel,
        matchStatus: String = "",
        isHost: Bool = false
    ) {
        self.matchId = matchId
        self.content = content
        self.matchStatus = matchStatus
        self.isHost = isHost
    }
}

extension MatchingMatchedCardItem {
    static let sample = MatchingMatchedCardItem(
        content: MatchingMatchedCardContentModel(
            profileImage: .imgProfileDefault,
            name: "정지영",
            participantCount: 3,
            gender: "여성",
            uploadedTime: "15분 전 올림",
            place: "시우다드 콘달",
            meetingTime: "오후 4:30",
            description: "오늘 저녁 바르셀로나에서 같이 타파스 드실 분 구해요!"
        ),
        isHost: true
    )
}

struct MatchingMatchListResponseModel: Decodable {
    let matches: [MatchingMatchSummaryModel]
}

struct MatchingMatchSummaryModel: Decodable {
    let matchId: Int
    let hostNickname: String
    let hostProfileImageUrl: String?
    let hostGender: String
    let placeName: String
    let meetingAt: String?
    let meetingTimeType: String
    let createdAt: String
    let content: String
    let matchStatus: String
}

extension MatchingMatchSummaryModel {
    func toMatchedCardItem(isHost: Bool = false) -> MatchingMatchedCardItem {
        return MatchingMatchedCardItem(
            matchId: matchId,
            content: MatchingMatchedCardContentModel(
                profileImageUrl: hostProfileImageUrl,
                name: hostNickname,
                participantCount: 1,
                gender: hostGender,
                uploadedTime: createdAt,
                place: placeName,
                meetingTime: meetingAt ?? meetingTimeType,
                description: content
            ),
            matchStatus: matchStatus,
            isHost: isHost
        )
    }
}

struct MatchingScheduleDetailResponseModel: Decodable {
    let matchId: Int
    let matchStatus: String
    let schedule: MatchingScheduleModel
    let openChatUrl: String
    let userNickname: String
    let meetingTimeType: String
}

struct MatchingScheduleModel: Decodable {
    let place: MatchingSchedulePlaceModel
    let scheduledAt: String
}

struct MatchingSchedulePlaceModel: Decodable {
    let googlePlaceId: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
}

struct MatchingManageScheduleRequestModel: Encodable {
    let scheduledAt: String
    let place: MatchingManageSchedulePlaceRequestModel
    let openChatUrl: String
}

struct MatchingManageSchedulePlaceRequestModel: Encodable {
    let googlePlaceId: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
}

struct MatchingScheduleDetailDisplayData {
    let cardItem: MatchingMatchedCardItem
    let placeName: String
    let placeAddress: String
    let latitude: Double
    let longitude: Double
    let scheduledAtText: String
    let openChatUrl: String
    let isHost: Bool
}

extension MatchingScheduleDetailResponseModel {
    func toDisplayData(
        cardItem: MatchingMatchedCardItem,
        isHost: Bool
    ) -> MatchingScheduleDetailDisplayData {
        return MatchingScheduleDetailDisplayData(
            cardItem: cardItem,
            placeName: schedule.place.name,
            placeAddress: schedule.place.address,
            latitude: schedule.place.latitude,
            longitude: schedule.place.longitude,
            scheduledAtText: schedule.scheduledAt,
            openChatUrl: openChatUrl,
            isHost: isHost
        )
    }
>>>>>>> origin/feat/#76
}
