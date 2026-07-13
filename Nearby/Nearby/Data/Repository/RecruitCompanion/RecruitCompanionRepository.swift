//
//  RecruitCompanionRepository.swift
//  Nearby
//
//  Created by 장지인 on 7/13/26.
//

protocol RecruitCompanionRepository {
    func searchPlaces(query: String, latitude: Double, longitude: Double) async throws -> [PlaceSearchResultItem]
    func fetchPlaceDetail(for item: PlaceSearchResultItem) async throws -> SelectedPlace
    func resetPlaceSearchSession()
    func recruitCompanion(request: RecruitCompanionRequestDTO) async throws -> RecruitCompanionResponseDTO
}

final class DefaultRecruitCompanionRepository {

    // MARK: - Properties

    private let googlePlaceService: GooglePlaceService
    private let recruitCompanionService: RecruitCompanionService

    // MARK: - Initializer

    init(googlePlaceService: GooglePlaceService, recruitCompanionService: RecruitCompanionService) {
        self.googlePlaceService = googlePlaceService
        self.recruitCompanionService = recruitCompanionService
    }
}

// MARK: - RecruitCompanionRepository

extension DefaultRecruitCompanionRepository: RecruitCompanionRepository {
    func searchPlaces(query: String, latitude: Double, longitude: Double) async throws -> [PlaceSearchResultItem] {
        try await withCheckedThrowingContinuation { continuation in
            googlePlaceService.searchPlaces(query: query, latitude: latitude, longitude: longitude) { result in
                continuation.resume(with: result)
            }
        }
    }

    func fetchPlaceDetail(for item: PlaceSearchResultItem) async throws -> SelectedPlace {
        defer { googlePlaceService.refreshSessionToken() }

        return try await withCheckedThrowingContinuation { continuation in
            googlePlaceService.fetchPlaceDetail(for: item) { result in
                continuation.resume(with: result)
            }
        }
    }

    func resetPlaceSearchSession() {
        googlePlaceService.refreshSessionToken()
    }

    func recruitCompanion(request: RecruitCompanionRequestDTO) async throws -> RecruitCompanionResponseDTO {
        try await recruitCompanionService.recruitCompanion(request: request)
    }
}
