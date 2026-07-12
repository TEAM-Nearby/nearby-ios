//
//  HostCompanionService.swift
//  Nearby
//
//  Created by h2e on 7/12/26.
//

import Foundation

protocol HostCompanionService {
    func fetchDetail(applicationId: Int) async throws -> HostCompanionDetailResponseDTO
    func allow(applicationId: Int) async throws -> HostCompanionAllowResponseDTO
    func reject(applicationId: Int, rejectionReason: String?) async throws -> HostCompanionRejectResponseDTO
}

final class DefaultHostCompanionService: HostCompanionService {
    private let provider: NetworkProvider
    
    init(provider: NetworkProvider) {
        self.provider = provider
    }
    
    func fetchDetail(applicationId: Int) async throws -> HostCompanionDetailResponseDTO {
        try await provider.request(
            HostCompanionTargetType.fetchDetail(applicationId: applicationId),
            responseType: HostCompanionDetailResponseDTO.self
        )
    }
    
    func allow(applicationId: Int) async throws -> HostCompanionAllowResponseDTO {
        try await provider.request(
            HostCompanionTargetType.allow(applicationId: applicationId),
            responseType: HostCompanionAllowResponseDTO.self
        )
    }
    
    func reject(applicationId: Int, rejectionReason: String?) async throws -> HostCompanionRejectResponseDTO {
        try await provider.request(
            HostCompanionTargetType.reject(applicationId: applicationId, rejectionReason: rejectionReason),
            responseType: HostCompanionRejectResponseDTO.self
        )
    }
}
