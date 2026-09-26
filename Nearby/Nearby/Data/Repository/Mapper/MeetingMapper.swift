//
//  MeetingMapper.swift
//  Nearby
//
//  Created by h2e on 9/26/26.
//

import Foundation

enum MeetingMapper {
    static func map(_ dto: MeetingResponseDTO) -> Meeting {
        Meeting(
            meetingID: dto.meetingId,
            matchID: dto.matchId,
            companion: Meeting.Companion(
                userID: dto.companion.userId,
                nickname: dto.companion.nickname,
                gender: dto.companion.gender,
                profileImageURL: dto.companion.profileImageUrl
            ),
            placeName: dto.placeName,
            meetingAt: dto.meetingAt?.toDate(),
            meetingTimeType: dto.meetingTimeType,
            isCheckedIn: dto.isCheckedIn
        )
    }
    
    static func map(_ dto: MeetingDetailResponseDTO) -> MeetingDetail {
        MeetingDetail(
            meetingID: dto.meetingId,
            currentUserRole: dto.currentUserRole,
            hostNickname: dto.hostNickname,
            hostGender: dto.hostGender,
            hostProfileImageURL: dto.hostProfileImageUrl,
            placeName: dto.placeName,
            meetingAt: dto.meetingAt?.toDate(),
            meetingTimeType: dto.meetingTimeType,
            isCurrentUserCheckedIn: dto.currentUserCheckedIn,
            meetingStatus: dto.meetingStatus
        )
    }
}
