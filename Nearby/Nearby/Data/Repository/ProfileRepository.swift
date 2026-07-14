//
//  ProfileRepository.swift
//  Nearby
//

protocol ProfileRepository {
    func fetchDetail(profileId: Int) async throws -> ProfileResponseDTO
}

final class DefaultProfileRepository {
    private let service: ProfileService

    init(service: ProfileService) {
        self.service = service
    }
}

extension DefaultProfileRepository: ProfileRepository {
    func fetchDetail(profileId: Int) async throws -> ProfileResponseDTO {
        try await service.fetchDetail(profileId: profileId)
    }
}
