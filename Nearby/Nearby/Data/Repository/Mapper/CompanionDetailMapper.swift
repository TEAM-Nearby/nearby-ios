//
//  CompanionDetailMapper.swift
//  Nearby
//
//  Created by soomin on 9/21/26.
//

import Foundation

enum CompanionDetailMapper {
    static func map(_ dto: CompanionDetailResponseDTO) -> CompanionDetail {
        CompanionDetail(
            postID: dto.postId,
            hostUserID: dto.hostUserId,
            hostProfileID: dto.hostProfileId,
            googlePlaceID: dto.googlePlaceId,
            city: dto.city,
            timeZoneID: dto.timeZoneId,
            currentLocalTime: NearbyDateParser.parseInstant(dto.currentLocalTime),
            meetingAt: NearbyDateParser.parseLocal(dto.meetingAt, timeZoneID: dto.timeZoneId),
            maxParticipants: dto.maxParticipants,
            content: dto.content,
            isRecruiting: dto.status == "RECRUITING",
            meetingTimeType: CompanionMapper.mapMeetingTimeType(dto.meetingTimeType),
            expiresAt: NearbyDateParser.parseInstant(dto.expiresAt),
            participantCount: dto.participantCount,
            participants: dto.participants.map {
                CompanionParticipant(userID: $0.userId, profileImageURL: $0.profileImageUrl)
            },
            hasNotApplied: dto.applyStatus == "NOT_APPLIED",
            hostProfile: CompanionHostProfile(
                nickname: dto.hostProfileSummary.nickname,
                gender: CompanionMapper.mapGender(dto.hostProfileSummary.gender),
                profileImageURL: dto.hostProfileSummary.profileImageUrl.flatMap(URL.init(string:)),
                introduction: dto.hostProfileSummary.intro,
                mannerScore: dto.hostProfileSummary.mannerScore,
                isPhoneVerified: dto.hostProfileSummary.phoneVerifiedAt != nil,
                keywords: dto.hostProfileSummary.keywords
            )
        )
    }
}
