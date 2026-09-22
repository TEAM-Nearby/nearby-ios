//
//  CompanionService.swift
//  Nearby
//
//  Created by soomin on 7/13/26.
//

protocol CompanionService {
    func fetchList(query: CompanionListQuery) async throws -> CompanionListResponseDTO
}

final class DefaultCompanionService {
    
    // MARK: - Property
    
    private let networkProvider: any NetworkProviding
    
    // MARK: - Initializer
    
    init(networkProvider: any NetworkProviding) {
        self.networkProvider = networkProvider
    }
}

extension DefaultCompanionService: CompanionService {
    func fetchList(query: CompanionListQuery) async throws -> CompanionListResponseDTO {
        try await networkProvider.request(
            CompanionTarget.list(query),
            responseType: CompanionListResponseDTO.self
        )
    }
}
