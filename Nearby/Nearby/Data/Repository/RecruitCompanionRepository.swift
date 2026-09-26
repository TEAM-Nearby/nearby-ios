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
    func recruitCompanion(_ submission: RecruitCompanionSubmission) async throws
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

    func recruitCompanion(_ submission: RecruitCompanionSubmission) async throws {
        let request = RecruitCompanionRequestDTO(
            place: RecruitCompanionRequestDTO.Place(
                googlePlaceId: submission.place.placeID,
                name: submission.place.name,
                address: submission.place.address,
                latitude: submission.place.latitude,
                longitude: submission.place.longitude,
                category: submission.place.category
            ),
            meetingTimeType: submission.meetingAt == nil ? .now : .scheduled,
            // TODO: 스프린트 국제 시간 적용 시 UTC 직렬화로 복구
            meetingAt: submission.meetingAt?.apiDateString,
            maxParticipants: submission.maxParticipants,
            styleKeywords: submission.styleKeywords,
            content: submission.content,
            openChatUrl: submission.openChatURL
        )
        _ = try await recruitCompanionService.recruitCompanion(request: request)
    }
}
