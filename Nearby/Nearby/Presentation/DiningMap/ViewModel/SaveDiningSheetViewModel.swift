//
//  SaveDiningSheetViewModel.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import Combine
import CoreLocation

enum DiningFavoriteSortOption: CaseIterable {
    case latest
    case oldest

    var title: String {
        switch self {
        case .latest: "최신순"
        case .oldest: "오래된 순"
        }
    }

    var serverKey: String {
        switch self {
        case .latest: "LATEST"
        case .oldest: "OLDEST"
        }
    }
}

final class SaveDiningSheetViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case locationDidUpdate(CLLocationCoordinate2D)
        case refresh
        case categoryDidSelect(DiningCategory)
        case sortDidSelect(DiningFavoriteSortOption)
        case restaurantDidSelect(Int)
        case bookmarkDidTap(Int)
    }
    
    // MARK: - Output
    
    struct Output {
        let selectedCategory = CurrentValueSubject<DiningCategory, Never>(.restaurant)
        let selectedSort = CurrentValueSubject<DiningFavoriteSortOption, Never>(.latest)
        let totalCount = CurrentValueSubject<Int, Never>(0)
        let restaurants = CurrentValueSubject<[NearDiningCellItem], Never>([])
        let mapMarkers = CurrentValueSubject<[CompanionMapMarkerData], Never>([])
        let selectedRestaurant = PassthroughSubject<NearDiningCellItem, Never>()
        let favoriteDidUpdate = PassthroughSubject<(placeId: Int, isFavorite: Bool), Never>()
        let error = PassthroughSubject<Error, Never>()
    }
    
    // MARK: - Properties

    let output = Output()

    private let repository: DiningMapRepository
    private var currentCoordinate: CLLocationCoordinate2D?
    private var fetchTask: Task<Void, Never>?
    private var favoriteTasks: [Int: Task<Void, Never>] = [:]
    
    var restaurantCount: Int { output.restaurants.value.count }
    
    // MARK: - Initializer
    
    init(repository: DiningMapRepository) {
        self.repository = repository
    }

    deinit {
        fetchTask?.cancel()
        favoriteTasks.values.forEach { $0.cancel() }
    }
    
    // MARK: - Methods
    
    func restaurant(at index: Int) -> NearDiningCellItem {
        output.restaurants.value[index]
    }

    func updateFavorite(placeId: Int, isFavorite: Bool) {
        guard !isFavorite else { return }
        removeRestaurant(placeId: placeId)
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .locationDidUpdate(let coordinate):
            currentCoordinate = coordinate
            fetchFavorites()
        case .refresh:
            fetchFavorites()
        case .categoryDidSelect(let category):
            output.selectedCategory.send(category)
            fetchFavorites()
        case .sortDidSelect(let sort):
            output.selectedSort.send(sort)
            fetchFavorites()
        case .restaurantDidSelect(let index):
            guard output.restaurants.value.indices.contains(index) else { return }
            output.selectedRestaurant.send(restaurant(at: index))
        case .bookmarkDidTap(let index):
            removeFavorite(at: index)
        }
    }
}

private extension SaveDiningSheetViewModel {
    func fetchFavorites() {
        guard let currentCoordinate else { return }

        fetchTask?.cancel()
        let category = output.selectedCategory.value
        let sort = output.selectedSort.value

        fetchTask = Task { [weak self] in
            guard let self else { return }

            do {
                let response = try await repository.fetchFavorites(
                    query: DiningFavoritesQuery(
                        latitude: currentCoordinate.latitude,
                        longitude: currentCoordinate.longitude,
                        category: category.serverKey,
                        sort: sort.serverKey
                    )
                )
                guard !Task.isCancelled else { return }
                let restaurants = await favoriteRestaurants(
                    from: response.favorites,
                    coordinate: currentCoordinate
                )
                guard !Task.isCancelled else { return }
                output.totalCount.send(response.totalCount)
                output.restaurants.send(restaurants)
                updateMapMarkers(from: restaurants)
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                output.error.send(error)
            }
        }
    }

    func removeFavorite(at index: Int) {
        let restaurants = output.restaurants.value
        guard
            restaurants.indices.contains(index),
            let placeId = restaurants[index].placeId,
            favoriteTasks[placeId] == nil
        else { return }

        favoriteTasks[placeId] = Task { [weak self] in
            guard let self else { return }
            defer { favoriteTasks[placeId] = nil }

            do {
                let response = try await repository.updateFavorite(placeId: placeId, isFavorite: false)
                guard !Task.isCancelled else { return }
                removeRestaurant(placeId: placeId)
                output.favoriteDidUpdate.send((placeId, response.isFavorite))
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                output.error.send(error)
            }
        }
    }

    func removeRestaurant(placeId: Int) {
        var restaurants = output.restaurants.value
        guard let index = restaurants.firstIndex(where: { $0.placeId == placeId }) else { return }
        restaurants.remove(at: index)
        output.restaurants.send(restaurants)
        updateMapMarkers(from: restaurants)
        output.totalCount.send(max(0, output.totalCount.value - 1))
    }

    func favoriteRestaurants(
        from favorites: [DiningFavoritePlaceDTO],
        coordinate: CLLocationCoordinate2D
    ) async -> [NearDiningCellItem] {
        var restaurants = favorites.map(NearDiningCellItem.init(dto:))

        await withTaskGroup(of: (Int, DiningDetailResponseDTO?).self) { group in
            for (index, favorite) in favorites.enumerated() {
                group.addTask { [repository] in
                    let response = try? await repository.fetchPlaceDetail(
                        query: DiningDetailQuery(
                            placeId: favorite.placeId,
                            latitude: coordinate.latitude,
                            longitude: coordinate.longitude
                        )
                    )
                    return (index, response)
                }
            }

            for await (index, response) in group {
                guard let response else { continue }
                restaurants[index] = NearDiningCellItem(dto: response)
            }
        }

        return restaurants
    }

    @MainActor
    func updateMapMarkers(from restaurants: [NearDiningCellItem]) {
        output.mapMarkers.send(
            restaurants.compactMap {
                CompanionMapMarkerData(diningItem: $0, style: .savedRestaurant)
            }
        )
    }
}
