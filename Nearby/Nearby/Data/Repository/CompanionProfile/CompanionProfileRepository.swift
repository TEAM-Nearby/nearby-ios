//
//  CompanionProfileRepository.swift
//  Nearby
//

protocol CompanionProfileRepository {
    func fetchDetail(profileId: Int) async throws -> CompanionProfileResponseDTO
}

final class DefaultCompanionProfileRepository {
    private let service: CompanionProfileService

    init(service: CompanionProfileService) {
        self.service = service
    }
}

extension DefaultCompanionProfileRepository: CompanionProfileRepository {
    func fetchDetail(profileId: Int) async throws -> CompanionProfileResponseDTO {
        try await service.fetchDetail(profileId: profileId)
    }
}
