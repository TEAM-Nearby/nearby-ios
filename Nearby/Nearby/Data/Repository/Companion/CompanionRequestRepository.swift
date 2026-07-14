//
//  CompanionRequestRepository.swift
//  Nearby
//
//  Created by 신서연 on 7/14/26.
//

protocol CompanionRequestRepository {
    func fetchRequests(direction: CompanionRequestDirection) async throws -> CompanionRequestListResponseDTO
}

final class DefaultCompanionRequestRepository {

    // MARK: - Property

    private let service: CompanionRequestService

    // MARK: - Initializer

    init(service: CompanionRequestService) {
        self.service = service
    }
}

// MARK: - CompanionRequestRepository

extension DefaultCompanionRequestRepository: CompanionRequestRepository {

    func fetchRequests(direction: CompanionRequestDirection) async throws -> CompanionRequestListResponseDTO {
        try await service.fetchRequests(direction: direction)
    }
}
