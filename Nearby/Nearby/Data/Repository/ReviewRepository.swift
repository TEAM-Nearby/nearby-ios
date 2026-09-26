//
//  ReviewRepository.swift
//  Nearby
//
//  Created by h2e on 7/14/26.
//

protocol ReviewRepository {
    func createReview(meetingId: Int, review: NewReview) async throws
    func fetchReviewTargets(meetingId: Int) async throws -> ReviewTargets
    func completeMeeting(meetingId: Int) async throws -> MeetingCompletion
}

final class DefaultReviewRepository {
    private let service: ReviewService

    init(service: ReviewService) {
        self.service = service
    }
}

// MARK: - ReviewRepository

extension DefaultReviewRepository: ReviewRepository {
    func createReview(meetingId: Int, review: NewReview) async throws {
        _ = try await service.createReview(meetingId: meetingId, request: ReviewMapper.map(review))
    }

    func fetchReviewTargets(meetingId: Int) async throws -> ReviewTargets {
        let response = try await service.fetchReviewTargets(meetingId: meetingId)
        return ReviewMapper.map(response)
    }
    
    func completeMeeting(meetingId: Int) async throws -> MeetingCompletion {
        let response = try await service.completeMeeting(meetingId: meetingId)
        return ReviewMapper.map(response)
    }
}
