//
//  DiningRepository.swift
//  Nearby
//
//  Created by soomin on 7/14/26.
//

protocol DiningRepository {
    func fetchPlaces(query: DiningListQuery) async throws -> DiningListResponseDTO
    func fetchPlaceDetail(query: DiningDetailQuery) async throws -> DiningDetailResponseDTO
}

final class DefaultDiningRepository: DiningRepository {
    private let service: DiningService

    init(service: DiningService) {
        self.service = service
    }

    func fetchPlaces(query: DiningListQuery) async throws -> DiningListResponseDTO {
        try await service.fetchPlaces(query: query)
    }

    func fetchPlaceDetail(query: DiningDetailQuery) async throws -> DiningDetailResponseDTO {
        try await service.fetchPlaceDetail(query: query)
    }
}
