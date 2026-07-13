//
//  ReviewService.swift
//  Nearby
//
//  Created by h2e on 7/14/26.
//

protocol ReviewService {
    func createReview(meetingId: Int, request: CreateReviewRequestDTO) async throws -> CreateReviewResponseDTO
}

final class DefaultReviewService: ReviewService {
    private let networkProvider: NetworkProvider

    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }

    func createReview(meetingId: Int, request: CreateReviewRequestDTO) async throws -> CreateReviewResponseDTO {
        try await networkProvider.request(
            ReviewTarget.create(meetingId: meetingId, request: request),
            responseType: CreateReviewResponseDTO.self
        )
    }
}
