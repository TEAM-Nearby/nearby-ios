//
//  CompanionRepository.swift
//  Nearby
//
//  Created by soomin on 7/13/26.
//

protocol CompanionRepository {
    func fetchList(query: CompanionListQuery) async throws -> CompanionListResponseDTO
}

final class DefaultCompanionRepository {

    // MARK: - Property

    private let service: CompanionService

    // MARK: - Initializer

    init(service: CompanionService) {
        self.service = service
    }
}

extension DefaultCompanionRepository: CompanionRepository {
    func fetchList(query: CompanionListQuery) async throws -> CompanionListResponseDTO {
        try await service.fetchList(query: query)
    }
}
