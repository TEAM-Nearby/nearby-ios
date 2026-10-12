//
//  RecruitCompanionRepository.swift
//  Nearby
//
//  Created by 장지인 on 7/13/26.
//

protocol RecruitCompanionRepository {
    func searchPlaces(query: String, latitude: Double, longitude: Double) async throws -> [PlaceSearchResultItem]
    func recruitCompanion(_ submission: RecruitCompanionSubmission) async throws
}

final class DefaultRecruitCompanionRepository {

    // MARK: - Properties

    private let recruitCompanionService: RecruitCompanionService

    // MARK: - Initializer

    init(recruitCompanionService: RecruitCompanionService) {
        self.recruitCompanionService = recruitCompanionService
    }
}

// MARK: - RecruitCompanionRepository

extension DefaultRecruitCompanionRepository: RecruitCompanionRepository {
    func searchPlaces(query: String, latitude: Double, longitude: Double) async throws -> [PlaceSearchResultItem] {
        let response = try await recruitCompanionService.searchPlaces(
            query: PlaceSearchQuery(
                query: query,
                latitude: latitude,
                longitude: longitude,
                radiusMeters: 20_000,
                languageCode: "ko",
                pageSize: 20
            )
        )

        return response.places.map {
            PlaceSearchResultItem(
                placeID: $0.googlePlaceId,
                name: $0.name,
                address: $0.address,
                latitude: $0.latitude,
                longitude: $0.longitude,
                category: $0.category.flatMap(PlaceCategory.init(rawValue:)) ?? .other
            )
        }
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
