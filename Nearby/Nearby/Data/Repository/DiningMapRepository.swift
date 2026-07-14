//
//  DiningMapRepository.swift
//  Nearby
//
//  Created by soomin on 7/14/26.
//

protocol DiningMapRepository {
    func fetchPlaces(query: DiningListQuery) async throws -> DiningListResponseDTO
    func fetchPlaceDetail(query: DiningDetailQuery) async throws -> DiningDetailResponseDTO
}

final class DefaultDiningMapRepository: DiningMapRepository {
    private let service: DiningMapService

    init(service: DiningMapService) {
        self.service = service
    }

    func fetchPlaces(query: DiningListQuery) async throws -> DiningListResponseDTO {
        try await service.fetchPlaces(query: query)
    }

    func fetchPlaceDetail(query: DiningDetailQuery) async throws -> DiningDetailResponseDTO {
        try await service.fetchPlaceDetail(query: query)
    }
}
