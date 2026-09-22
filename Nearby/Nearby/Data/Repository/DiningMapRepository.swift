//
//  DiningMapRepository.swift
//  Nearby
//
//  Created by soomin on 7/14/26.
//

protocol DiningMapRepository {
    func fetchPlaces(criteria: DiningPlaceSearchCriteria) async throws -> [DiningPlace]
    func fetchPlaceDetail(criteria: DiningPlaceDetailCriteria) async throws -> DiningPlace
    func fetchFavorites(criteria: DiningFavoritesCriteria) async throws -> DiningFavoriteList
    func updateFavorite(placeId: Int, isFavorite: Bool) async throws -> Bool
}

final class DefaultDiningMapRepository: DiningMapRepository {
    private let service: DiningMapService

    init(service: DiningMapService) {
        self.service = service
    }

    func fetchPlaces(criteria: DiningPlaceSearchCriteria) async throws -> [DiningPlace] {
        let response = try await service.fetchPlaces(query: DiningMapMapper.map(criteria))
        return response.places.map(DiningMapMapper.map)
    }

    func fetchPlaceDetail(criteria: DiningPlaceDetailCriteria) async throws -> DiningPlace {
        let response = try await service.fetchPlaceDetail(query: DiningMapMapper.map(criteria))
        return DiningMapMapper.map(response)
    }

    func fetchFavorites(criteria: DiningFavoritesCriteria) async throws -> DiningFavoriteList {
        let response = try await service.fetchFavorites(query: DiningMapMapper.map(criteria))
        return DiningFavoriteList(totalCount: response.totalCount, places: response.favorites.map(DiningMapMapper.map))
    }

    func updateFavorite(placeId: Int, isFavorite: Bool) async throws -> Bool {
        let response = try await service.updateFavorite(placeId: placeId, isFavorite: isFavorite)
        return response.isFavorite
    }
}
