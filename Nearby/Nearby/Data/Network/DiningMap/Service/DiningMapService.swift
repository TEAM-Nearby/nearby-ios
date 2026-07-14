//
//  DiningMapService.swift
//  Nearby
//
//  Created by soomin on 7/14/26.
//

protocol DiningMapService {
    func fetchPlaces(query: DiningListQuery) async throws -> DiningListResponseDTO
    func fetchPlaceDetail(query: DiningDetailQuery) async throws -> DiningDetailResponseDTO
}

final class DefaultDiningMapService {
    
    // MARK: - Property
    
    private let networkProvider: NetworkProvider
    
    // MARK: - Initializer
    
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
}

// MARK: - DiningMapService

extension DefaultDiningMapService: DiningMapService {
    func fetchPlaces(query: DiningListQuery) async throws -> DiningListResponseDTO {
        try await networkProvider.request(
            DiningMapTarget.list(query),
            responseType: DiningListResponseDTO.self
        )
    }
    
    func fetchPlaceDetail(query: DiningDetailQuery) async throws -> DiningDetailResponseDTO {
        try await networkProvider.request(
            DiningMapTarget.detail(query),
            responseType: DiningDetailResponseDTO.self
        )
    }
}
