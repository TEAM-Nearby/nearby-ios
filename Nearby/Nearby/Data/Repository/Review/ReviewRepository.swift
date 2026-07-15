//
//  ReviewRepository.swift
//  Nearby
//
//  Created by h2e on 7/14/26.
//

protocol ReviewRepository {
    func createReview(meetingId: Int, request: CreateReviewRequestDTO) async throws -> CreateReviewResponseDTO
    func fetchReviewTargets(meetingId: Int) async throws -> ReviewTargetsResponseDTO
    func completeMeeting(meetingId: Int) async throws -> ReviewCompleteDTO
}

final class DefaultReviewRepository {
    private let service: ReviewService

    init(service: ReviewService) {
        self.service = service
    }
}

// MARK: - ReviewRepository

extension DefaultReviewRepository: ReviewRepository {
    func createReview(meetingId: Int, request: CreateReviewRequestDTO) async throws -> CreateReviewResponseDTO {
        try await service.createReview(meetingId: meetingId, request: request)
    }

    func fetchReviewTargets(meetingId: Int) async throws -> ReviewTargetsResponseDTO {
        try await service.fetchReviewTargets(meetingId: meetingId)
    }
    
    func completeMeeting(meetingId: Int) async throws -> ReviewCompleteDTO {
        try await service.completeMeeting(meetingId: meetingId)
    }
}
