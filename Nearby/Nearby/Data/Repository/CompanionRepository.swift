//
//  CompanionRepository.swift
//  Nearby
//
//  Created by soomin on 7/13/26.
//

protocol CompanionRepository {
    func fetchList(criteria: CompanionSearchCriteria) async throws -> CompanionList
}

final class DefaultCompanionRepository {

    // MARK: - Property

    private let service: CompanionService

    // MARK: - Initializer

    init(service: CompanionService) {
        self.service = service
    }
}

extension DefaultCompanionRepository: CompanionRepository {
    func fetchList(criteria: CompanionSearchCriteria) async throws -> CompanionList {
        let query = CompanionListQuery(latitude: criteria.latitude, longitude: criteria.longitude,
                                       radiusMeters: criteria.radiusMeters, placeCategory: criteria.placeCategory.serverKey,
                                       sort: criteria.sort.serverKey)
        let response = try await service.fetchList(query: query)
        return CompanionMapper.map(response)
    }
}

private extension CompanionPlace.Category {
    var serverKey: String {
        switch self {
        case .restaurant: "RESTAURANT"
        case .cafe: "CAFE"
        case .pub: "PUB"
        case .museum: "MUSEUM"
        case .photoSpot: "PHOTO_SPOT"
        case .unknown: "OTHER"
        }
    }
}

private extension CompanionSearchCriteria.Sort {
    var serverKey: String {
        switch self {
        case .latest: "LATEST"
        case .nearest: "DISTANCE"
        case .closingSoon: "CLOSING_SOON"
        }
    }
}
