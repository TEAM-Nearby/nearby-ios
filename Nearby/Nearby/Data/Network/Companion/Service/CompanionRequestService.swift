//
//  CompanionRequestService.swift
//  Nearby
//
//  Created by 신서연 on 7/14/26.
//

protocol CompanionRequestService {
    func fetchRequests(direction: CompanionRequestDirection) async throws -> CompanionRequestListResponseDTO
}

final class DefaultCompanionRequestService {

    // MARK: - Property

    private let networkProvider: NetworkProvider

    // MARK: - Initializer

    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
}

// MARK: - CompanionRequestService

extension DefaultCompanionRequestService: CompanionRequestService {

    func fetchRequests(direction: CompanionRequestDirection) async throws -> CompanionRequestListResponseDTO {
        try await networkProvider.request(
            CompanionRequestTarget.list(direction: direction),
            responseType: CompanionRequestListResponseDTO.self
        )
    }
}
