//
//  HostCompanionService.swift
//  Nearby
//
//  Created by h2e on 7/12/26.
//

protocol HostCompanionService {
    func fetchDetail(applicationId: Int) async throws -> HostCompanionDetailResponseDTO
    func allow(applicationId: Int) async throws -> HostCompanionAllowResponseDTO
    func reject(applicationId: Int, request: HostCompanionRejectRequestDTO) async throws -> HostCompanionRejectResponseDTO
}

final class DefaultHostCompanionService {
    
    // MARK: - Property
    
    private let networkProvider: NetworkProvider
    
    // MARK: - Initializer
    
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
}

// MARK: - HostCompanionService

extension DefaultHostCompanionService: HostCompanionService {
func fetchDetail(applicationId: Int) async throws -> HostCompanionDetailResponseDTO {
        try await networkProvider.request(
            HostCompanionTarget.fetchDetail(applicationId: applicationId),
            responseType: HostCompanionDetailResponseDTO.self
        )
    }

    func allow(applicationId: Int) async throws -> HostCompanionAllowResponseDTO {
        try await networkProvider.request(
            HostCompanionTarget.allow(applicationId: applicationId),
            responseType: HostCompanionAllowResponseDTO.self
        )
    }

    func reject(applicationId: Int, request: HostCompanionRejectRequestDTO) async throws -> HostCompanionRejectResponseDTO {
        try await networkProvider.request(
            HostCompanionTarget.reject(applicationId: applicationId, request: request),
            responseType: HostCompanionRejectResponseDTO.self
        )
    }
}
