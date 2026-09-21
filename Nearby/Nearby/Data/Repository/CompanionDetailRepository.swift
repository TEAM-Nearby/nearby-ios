//
//  CompanionDetailRepository.swift
//  Nearby
//
//  Created by soomin on 7/13/26.
//

protocol CompanionDetailRepository {
    func fetchDetail(postId: Int) async throws -> CompanionDetail
    func apply(postId: Int) async throws
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
    func fetchDetail(postId: Int) async throws -> CompanionDetail {
        let response = try await service.fetchDetail(postId: postId)
        return CompanionDetailMapper.map(response)
    }

    func apply(postId: Int) async throws {
        _ = try await service.apply(postId: postId)
    }
}
