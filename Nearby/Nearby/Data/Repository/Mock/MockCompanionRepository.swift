//
//  MockCompanionRepository.swift
//  Nearby
//
//  Created by soomin on 9/22/26.
//

import Foundation

final class MockCompanionRepository {}

extension MockCompanionRepository: CompanionRepository {
    func fetchList(criteria: CompanionSearchCriteria) async throws -> CompanionList {
        try Task.checkCancellation()

        let now = Date()
        let posts = [
            makePost(postId: 1, placeId: 101, placeName: "La Paradeta",
                     latitude: criteria.latitude + 0.001, longitude: criteria.longitude + 0.001,
                     distanceMeters: 250, category: criteria.placeCategory,
                     hostName: "수민", content: "오늘 저녁 같이 해산물 먹어요!!!!\n제발 아무나!!!!!",
                     meetingTimeType: .scheduled, meetingAt: now.addingTimeInterval(7_200),
                     createdAt: now.addingTimeInterval(-600)),
            makePost(postId: 2, placeId: 101, placeName: "La Paradeta",
                     latitude: criteria.latitude + 0.001, longitude: criteria.longitude + 0.001,
                     distanceMeters: 250, category: criteria.placeCategory,
                     hostName: "지인", content: "저랑 놀 사람~~~ 저 미국이에요\n미국으로 오세요",
                     meetingTimeType: .now, meetingAt: nil,
                     createdAt: now.addingTimeInterval(-1_800)),
            makePost(postId: 3, placeId: 102, placeName: "El Nacional",
                     latitude: criteria.latitude - 0.001, longitude: criteria.longitude - 0.001,
                     distanceMeters: 100, category: criteria.placeCategory,
                     hostName: "서연", content: "안녕하세요 서여니입니다\n저 맛집 많이 알아요",
                     meetingTimeType: .undecided, meetingAt: nil,
                     createdAt: now.addingTimeInterval(-3_600))
        ]

        let sortedPosts: [CompanionPost]
        switch criteria.sort {
        case .latest:
            sortedPosts = posts.sorted { ($0.createdAt ?? .distantPast) > ($1.createdAt ?? .distantPast) }
        case .nearest:
            sortedPosts = posts.sorted { $0.place.distanceMeters < $1.place.distanceMeters }
        case .closingSoon:
            sortedPosts = posts.sorted { ($0.meetingAt ?? .distantFuture) < ($1.meetingAt ?? .distantFuture) }
        }

        return CompanionList(summaryText: "내 주변 \(posts.count)개의 동행이 있어요", posts: sortedPosts)
    }
}

private extension MockCompanionRepository {
    func makePost(postId: Int, placeId: Int, placeName: String, latitude: Double, longitude: Double,
                  distanceMeters: Int, category: CompanionPlace.Category,
                  hostName: String, content: String, meetingTimeType: CompanionMeetingTimeType,
                  meetingAt: Date?, createdAt: Date) -> CompanionPost {
        CompanionPost(
            postID: postId,
            host: CompanionHost(nickname: hostName, gender: .female),
            place: CompanionPlace(
                placeID: placeId,
                googlePlaceID: "mock-google-place-\(placeId)",
                name: placeName,
                category: category,
                latitude: latitude,
                longitude: longitude,
                distanceMeters: distanceMeters,
                imageURL: nil,
                usesDefaultImage: true
            ),
            contentPreview: content,
            meetingTimeType: meetingTimeType,
            meetingAt: meetingAt,
            meetingAtText: nil,
            participantCount: 2,
            participants: [
                CompanionParticipant(userID: postId * 10, profileImageURL: nil),
                CompanionParticipant(userID: postId * 10 + 1, profileImageURL: nil)
            ],
            participantSummaryText: "2/4명",
            createdAt: createdAt,
            createdAgoText: "방금 전"
        )
    }
}
