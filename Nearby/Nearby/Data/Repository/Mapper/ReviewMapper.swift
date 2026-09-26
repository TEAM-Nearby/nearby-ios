//
//  ReviewMapper.swift
//  Nearby
//
//  Created by h2e on 9/26/26.
//

import Foundation

enum ReviewMapper {
    static func map(_ dto: ReviewTargetsResponseDTO) -> ReviewTargets {
        ReviewTargets(
            currentUserRole: dto.currentUserRole,
            canCompleteMeeting: dto.canCompleteMeeting,
            reviewees: dto.reviewTargets.map(map)
        )
    }
    
    static func map(_ dto: ReviewTargetDTO) -> Reviewee {
        Reviewee(
            userID: dto.revieweeUserId,
            nickname: dto.nickname,
            profileImageURL: dto.profileImageUrl,
            cityName: dto.cityName,
            meetingDate: DateFormatter.cached(format: "yyyy-MM-dd").date(from: dto.meetingDate),
            isCheckedIn: dto.isCheckedIn,
            hasWrittenReview: dto.hasWrittenReview
        )
    }
}
