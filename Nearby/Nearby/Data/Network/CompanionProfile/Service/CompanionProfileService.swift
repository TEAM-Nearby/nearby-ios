//
//  CompanionProfileService.swift
//  Nearby
//
//  Created by h2e on 10/14/26.
//

protocol CompanionProfileService {
    func fetch(profileID: Int) async throws -> CompanionProfileDetailResponseDTO
    func update(request: UpdateCompanionProfileRequestDTO) async throws -> CompanionProfileDetailResponseDTO
}

final class DefaultCompanionProfileService {

    // MARK: - Property

    private let networkProvider: any NetworkProviding

    // MARK: - Initializer

    init(networkProvider: any NetworkProviding) {
        self.networkProvider = networkProvider
    }
}

// MARK: - CompanionProfileService

extension DefaultCompanionProfileService: CompanionProfileService {

    func fetch(profileID: Int) async throws -> CompanionProfileDetailResponseDTO {
        try await networkProvider.request(CompanionProfileTarget.detail(profileID: profileID), responseType: CompanionProfileDetailResponseDTO.self)
    }

    func update(request: UpdateCompanionProfileRequestDTO) async throws -> CompanionProfileDetailResponseDTO {
        try await networkProvider.request(CompanionProfileTarget.update(request: request), responseType: CompanionProfileDetailResponseDTO.self)
    }
}
