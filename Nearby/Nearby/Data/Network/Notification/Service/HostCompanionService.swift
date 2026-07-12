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
    func decline(applicationId: Int, rejectionReason: String?) async throws -> HostCompanionDeclineResponseDTO
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
    
    func decline(applicationId: Int, rejectionReason: String?) async throws -> HostCompanionDeclineResponseDTO {
        try await provider.request(
            HostCompanionTargetType.decline(applicationId: applicationId, rejectionReason: rejectionReason),
            responseType: HostCompanionDeclineResponseDTO.self
        )
    }
}
