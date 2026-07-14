//
//  ReviewService.swift
//  Nearby
//
//  Created by h2e on 7/14/26.
//

protocol ReviewService {
    func createReview(meetingId: Int, request: CreateReviewRequestDTO) async throws -> CreateReviewResponseDTO
    func fetchReviewTargets(meetingId: Int) async throws -> ReviewTargetsResponseDTO
    func completeMeeting(meetingId: Int) async throws -> ReviewCompleteDTO
}

final class DefaultReviewService {
    private let networkProvider: NetworkProvider

    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
}

// MARK: - ReviewService

extension DefaultReviewService: ReviewService {
    func createReview(meetingId: Int, request: CreateReviewRequestDTO) async throws -> CreateReviewResponseDTO {
        try await networkProvider.request(
            ReviewTarget.create(meetingId: meetingId, request: request),
            responseType: CreateReviewResponseDTO.self
        )
    }

    func fetchReviewTargets(meetingId: Int) async throws -> ReviewTargetsResponseDTO {
        try await networkProvider.request(
            ReviewTarget.fetchTargets(meetingId: meetingId),
            responseType: ReviewTargetsResponseDTO.self
        )
    }
    
    func completeMeeting(meetingId: Int) async throws -> ReviewCompleteDTO {
        try await networkProvider.request(
            ReviewTarget.complete(meetingId: meetingId),
            responseType: ReviewCompleteDTO.self
        )
    }
}
