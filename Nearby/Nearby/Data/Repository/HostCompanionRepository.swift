//
//  HostCompanionRepository.swift
//  Nearby
//
//  Created by h2e on 7/12/26.
//

import Foundation

protocol HostCompanionRepository {
    func fetchHostCompanionDetail(applicationId: Int) async throws -> HostCompanionDetailResponseDTO
    func allowApplication(applicationId: Int) async throws -> HostCompanionAllowResponseDTO
    func rejectApplication(applicationId: Int, reason: String?) async throws
}

final class DefaultHostCompanionRepository {
    
    // MARK: - Property
    
    private let hostCompanionService: HostCompanionService
    
    // MARK: - Initializer
    
    init(hostCompanionService: HostCompanionService) {
        self.hostCompanionService = hostCompanionService
    }
}

// MARK: - HostCompanionRepository

extension DefaultHostCompanionRepository: HostCompanionRepository {
    func fetchHostCompanionDetail(applicationId: Int) async throws -> HostCompanionDetailResponseDTO {
        try await hostCompanionService.fetchDetail(applicationId: applicationId)
    }
    
    func allowApplication(applicationId: Int) async throws -> HostCompanionAllowResponseDTO {
        try await hostCompanionService.allow(applicationId: applicationId)
    }
    
    func rejectApplication(applicationId: Int, reason: String?) async throws {
        _ = try await hostCompanionService.reject(
            applicationId: applicationId,
            request: HostCompanionRejectRequestDTO(rejectionReason: reason)
        )
    }
}
