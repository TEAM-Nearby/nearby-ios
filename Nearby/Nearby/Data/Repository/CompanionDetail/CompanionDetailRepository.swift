//
//  CompanionDetailRepository.swift
//  Nearby
//
//  Created by soomin on 7/13/26.
//

protocol CompanionDetailRepository {
    func fetchDetail(postId: Int) async throws -> CompanionDetailResponseDTO
}

final class DefaultCompanionDetailRepository {
    
    // MARK: - Property
    
    private let service: CompanionDetailService
    
    // MARK: - Initializer
    
    init(service: CompanionDetailService) {
        self.service = service
    }
}

// MARK: - CompanionDetailRepository

extension DefaultCompanionDetailRepository: CompanionDetailRepository {
    func fetchDetail(postId: Int) async throws -> CompanionDetailResponseDTO {
        try await service.fetchDetail(postId: postId)
    }
}
