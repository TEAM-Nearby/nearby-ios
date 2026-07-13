//
//  ReviewRepository.swift
//  Nearby
//
//  Created by h2e on 7/14/26.
//

protocol ReviewRepository {
    func createReview(meetingId: Int, request: CreateReviewRequestDTO) async throws -> CreateReviewResponseDTO
}

final class DefaultReviewRepository: ReviewRepository {
    private let service: ReviewService

    init(service: ReviewService) {
        self.service = service
    }

    func createReview(meetingId: Int, request: CreateReviewRequestDTO) async throws -> CreateReviewResponseDTO {
        try await service.createReview(meetingId: meetingId, request: request)
    }
}
