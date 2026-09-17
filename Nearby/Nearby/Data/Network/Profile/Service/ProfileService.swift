//
//  ProfileService.swift
//  Nearby
//

protocol ProfileService {
    func fetchDetail(profileId: Int) async throws -> ProfileResponseDTO
}

final class DefaultProfileService {
    private let networkProvider: any NetworkProviding

    init(networkProvider: any NetworkProviding) {
        self.networkProvider = networkProvider
    }
}

extension DefaultProfileService: ProfileService {
    func fetchDetail(profileId: Int) async throws -> ProfileResponseDTO {
        try await networkProvider.request(
            ProfileTarget.detail(profileId: profileId),
            responseType: ProfileResponseDTO.self
        )
    }
}
