//
//  RecruitCompanionService.swift
//  Nearby
//
//  Created by 장지인 on 7/13/26.
//

protocol RecruitCompanionService {
    func searchPlaces(query: PlaceSearchQuery) async throws -> PlaceSearchResponseDTO
    func recruitCompanion(request: RecruitCompanionRequestDTO) async throws -> RecruitCompanionResponseDTO
}

final class DefaultRecruitCompanionService {

    // MARK: - Property

    private let networkProvider: any NetworkProviding

    // MARK: - Initializer

    init(networkProvider: any NetworkProviding) {
        self.networkProvider = networkProvider
    }
}

// MARK: - RecruitCompanionService

extension DefaultRecruitCompanionService: RecruitCompanionService {
    func searchPlaces(query: PlaceSearchQuery) async throws -> PlaceSearchResponseDTO {
        try await networkProvider.request(
            RecruitCompanionTarget.searchPlaces(query),
            responseType: PlaceSearchResponseDTO.self
        )
    }

    func recruitCompanion(request: RecruitCompanionRequestDTO) async throws -> RecruitCompanionResponseDTO {
        try await networkProvider.request(
            RecruitCompanionTarget.recruitCompanion(request),
            responseType: RecruitCompanionResponseDTO.self
        )
        
    }
}
