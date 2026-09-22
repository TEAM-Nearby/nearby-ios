//
//  MockCompanionDetailRepository.swift
//  Nearby
//
//  Created by soomin on 9/22/26.
//

import Foundation

final class MockCompanionDetailRepository {}

extension MockCompanionDetailRepository: CompanionDetailRepository {
    func fetchDetail(postId: Int) async throws -> CompanionDetail {
        try Task.checkCancellation()

        return CompanionDetail(
            postID: postId,
            hostUserID: 1_000 + postId,
            hostProfileID: 2_000 + postId,
            googlePlaceID: "mock-google-place-\(postId)",
            meetingAt: Date().addingTimeInterval(7_200),
            maxParticipants: 4,
            content: "서버 연동 전 테스트!!!!!!!!",
            isRecruiting: true,
            meetingTimeType: .scheduled,
            expiresAt: Date().addingTimeInterval(3_600),
            participantCount: 2,
            participants: [
                CompanionParticipant(userID: 10, profileImageURL: nil),
                CompanionParticipant(userID: 11, profileImageURL: nil)
            ],
            hasNotApplied: true,
            hostProfile: CompanionHostProfile(
                nickname: "수민",
                gender: .female,
                profileImageURL: nil,
                introduction: "저는 김수민입니다.",
                mannerScore: 4.8,
                isPhoneVerified: true,
                keywords: ["사진에 진심", "계획파"]
            )
        )
    }

    func apply(postId: Int) async throws {
        try Task.checkCancellation()
    }
}
