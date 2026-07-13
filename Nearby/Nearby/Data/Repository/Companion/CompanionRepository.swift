//
//  CompanionRepository.swift
//  Nearby
//

protocol CompanionRepository {
    func fetchList(query: CompanionListQuery) async throws -> CompanionListResponseDTO
}

final class DefaultCompanionRepository: CompanionRepository {
    private let service: CompanionService

    init(service: CompanionService) {
        self.service = service
    }

    func fetchList(query: CompanionListQuery) async throws -> CompanionListResponseDTO {
        try await service.fetchList(query: query)
    }
}
