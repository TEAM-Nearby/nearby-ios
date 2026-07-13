//
//  CompanionProfileService.swift
//  Nearby
//

protocol CompanionProfileService {
    func fetchDetail(profileId: Int) async throws -> CompanionProfileResponseDTO
}

final class DefaultCompanionProfileService {
    private let networkProvider: NetworkProvider

    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
}

extension DefaultCompanionProfileService: CompanionProfileService {
    func fetchDetail(profileId: Int) async throws -> CompanionProfileResponseDTO {
        try await networkProvider.request(
            CompanionProfileTarget.detail(profileId: profileId),
            responseType: CompanionProfileResponseDTO.self
        )
    }
}
