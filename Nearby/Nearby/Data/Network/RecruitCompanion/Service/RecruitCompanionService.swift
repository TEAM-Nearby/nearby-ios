//
//  RecruitCompanionService.swift
//  Nearby
//
//  Created by 장지인 on 7/13/26.
//

protocol RecruitCompanionService {
    func recruitCompanion(request: RecruitCompanionRequestDTO) async throws -> RecruitCompanionResponseDTO
}

final class DefaultRecruitCompanionService {

    // MARK: - Property

    private let networkProvider: NetworkProvider

    // MARK: - Initializer

    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
}

// MARK: - RecruitCompanionService

extension DefaultRecruitCompanionService: RecruitCompanionService {
    func recruitCompanion(request: RecruitCompanionRequestDTO) async throws -> RecruitCompanionResponseDTO {
        try await networkProvider.request(
            RecruitCompanionTarget.recruitCompanion(request),
            responseType: RecruitCompanionResponseDTO.self
        )
        
    }
}
