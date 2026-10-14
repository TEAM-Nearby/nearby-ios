//
//  CompanionProfileRepository.swift
//  Nearby
//
//  Created by h2e on 10/14/26.
//

protocol CompanionProfileRepository {
    func updateCompanionProfile(_ update: CompanionProfileUpdate) async throws -> CompanionProfile
}

final class DefaultCompanionProfileRepository {

    // MARK: - Property

    private let service: CompanionProfileService

    // MARK: - Initializer

    init(service: CompanionProfileService) {
        self.service = service
    }
}

// MARK: - CompanionProfileRepository

extension DefaultCompanionProfileRepository: CompanionProfileRepository {
    func updateCompanionProfile(_ update: CompanionProfileUpdate) async throws -> CompanionProfile {
        let response = try await service.update(request: CompanionProfileMapper.map(update))
        return CompanionProfileMapper.map(response)
    }
}
