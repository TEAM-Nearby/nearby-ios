//
//  DiningMapService.swift
//  Nearby
//
//  Created by soomin on 7/14/26.
//

protocol DiningMapService {
    func fetchPlaces(query: DiningListQuery) async throws -> DiningListResponseDTO
    func fetchPlaceDetail(query: DiningDetailQuery) async throws -> DiningDetailResponseDTO
    func fetchFavorites(query: DiningFavoritesQuery) async throws -> DiningFavoritesResponseDTO
    func updateFavorite(placeId: Int, isFavorite: Bool) async throws -> DiningFavoriteResponseDTO
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

    func fetchFavorites(query: DiningFavoritesQuery) async throws -> DiningFavoritesResponseDTO {
        try await networkProvider.request(
            DiningMapTarget.favorites(query),
            responseType: DiningFavoritesResponseDTO.self
        )
    }

    func updateFavorite(placeId: Int, isFavorite: Bool) async throws -> DiningFavoriteResponseDTO {
        let target: DiningMapTarget = isFavorite
            ? .registerFavorite(placeId: placeId)
            : .removeFavorite(placeId: placeId)

        return try await networkProvider.request(
            target,
            responseType: DiningFavoriteResponseDTO.self
        )
    }
}
