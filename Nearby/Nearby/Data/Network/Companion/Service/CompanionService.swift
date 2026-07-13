//
//  CompanionService.swift
//  Nearby
//
//  Created by soomin on 7/13/26.
//

protocol CompanionService {
    func fetchList(query: CompanionListQuery) async throws -> CompanionListResponseDTO
}

final class DefaultCompanionService: CompanionService {
    private let networkProvider: NetworkProvider

    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }

    func fetchList(query: CompanionListQuery) async throws -> CompanionListResponseDTO {
        try await networkProvider.request(
            CompanionTarget.list(query),
            responseType: CompanionListResponseDTO.self
        )
    }
}
