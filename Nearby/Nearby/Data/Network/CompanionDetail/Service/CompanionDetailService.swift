//
//  CompanionDetailService.swift
//  Nearby
//
//  Created by soomin on 7/13/26.
//

protocol CompanionDetailService {
    func fetchDetail(postId: Int) async throws -> CompanionDetailResponseDTO
    func apply(postId: Int) async throws -> CompanionApplyResponseDTO
}

final class DefaultCompanionDetailService {
    
    // MARK: - Property
    
    private let networkProvider: NetworkProvider
    
    // MARK: - Initializer
    
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
}

// MARK: - CompanionDetailService

extension DefaultCompanionDetailService: CompanionDetailService {
    func fetchDetail(postId: Int) async throws -> CompanionDetailResponseDTO {
        try await networkProvider.request(
            CompanionDetailTarget.detail(postId: postId),
            responseType: CompanionDetailResponseDTO.self
        )
    }

    func apply(postId: Int) async throws -> CompanionApplyResponseDTO {
        try await networkProvider.request(
            CompanionDetailTarget.apply(postId: postId),
            responseType: CompanionApplyResponseDTO.self
        )
    }
}
