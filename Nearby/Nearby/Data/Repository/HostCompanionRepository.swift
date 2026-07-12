//
//  HostCompanionRepository.swift
//  Nearby
//
//  Created by h2e on 7/12/26.
//

import Foundation

protocol HostCompanionRepository {
    func fetchHostCompanionDetail(applicatonId: Int) async throws -> HostCompanionDetailResponseDTO
    func allowApplication(applicationId: Int) async throws
    func rejectApplcation(applicationId: Int, reason: String?) async throws
}

final class DefaultHostComapnionRepository {
    
    // MARK: - Properties
    
    private let hostCompanionService: HostCompanionService
    
    // MARK: - Initializer
    
    init(hostCompanionService: HostCompanionService) {
        self.hostCompanionService = hostCompanionService
    }
}

// MARK: - HostCompanionRepository

extension DefaultHostComapnionRepository: HostCompanionRepository {
    func fetchHostCompanionDetail(applicatonId: Int) async throws -> HostCompanionDetailResponseDTO {
        let response = try await hostCompanionService.fetchDetail(applicationId: applicatonId)
    }
    
    func allowApplication(applicationId: Int) async throws {
        _ = try await hostCompanionService.allow(applicationId: applicationId)
    }
    
    func rejectApplcation(applicationId: Int, reason: String?) async throws {
        _ = try await hostCompanionService.reject(applicationId: applicationId, rejectionReason: reason)
    }
}
