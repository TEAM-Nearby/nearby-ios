//
//  NearDiningBottomSheetViewModel.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import Combine
import CoreLocation

final class NearDiningBottomSheetViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case locationDidUpdate(CLLocationCoordinate2D)
        case categoryDidSelect(DiningCategory)
        case restaurantDidSelect(Int)
        case bookmarkDidTap(Int)
    }

    // MARK: - Output
    
    struct Output {
        let selectedCategory = CurrentValueSubject<DiningCategory, Never>(.restaurant)
        let restaurants: CurrentValueSubject<[NearDiningCellItem], Never>
        let mapMarkers = CurrentValueSubject<[CompanionMapMarkerData], Never>([])
        let selectedRestaurant = PassthroughSubject<NearDiningCellItem, Never>()
        let error = PassthroughSubject<Error, Never>()
    }
    
    // MARK: - Properties

    let output: Output

    private let repository: DiningMapRepository
    private var currentCoordinate: CLLocationCoordinate2D?
    private var fetchTask: Task<Void, Never>?
    private var favoriteTasks: [Int: Task<Void, Never>] = [:]

    var restaurantCount: Int { output.restaurants.value.count }

    // MARK: - Initializer
    
    init(repository: DiningMapRepository) {
        self.repository = repository
        output = Output(restaurants: CurrentValueSubject([]))
    }

    deinit {
        fetchTask?.cancel()
        favoriteTasks.values.forEach { $0.cancel() }
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .locationDidUpdate(let coordinate):
            currentCoordinate = coordinate
            fetchRestaurants()
        case .categoryDidSelect(let category):
            output.selectedCategory.send(category)
            fetchRestaurants()
        case .restaurantDidSelect(let index):
            output.selectedRestaurant.send(restaurant(at: index))
        case .bookmarkDidTap(let index):
            updateFavorite(at: index)
        }
    }

    // MARK: - Methods
    
    func restaurant(at index: Int) -> NearDiningCellItem {
        output.restaurants.value[index]
    }

    func restaurant(placeId: Int) -> NearDiningCellItem? {
        output.restaurants.value.first { $0.placeId == placeId }
    }

    func updateFavorite(placeId: Int, isFavorite: Bool) {
        var restaurants = output.restaurants.value
        guard let index = restaurants.firstIndex(where: { $0.placeId == placeId }) else { return }
        restaurants[index].isBookmarked = isFavorite
        output.restaurants.send(restaurants)
        updateMapMarkers(from: restaurants)
    }
}

private extension NearDiningBottomSheetViewModel {
    func fetchRestaurants() {
        guard let currentCoordinate else { return }

        fetchTask?.cancel()
        let category = output.selectedCategory.value

        fetchTask = Task { [weak self] in
            guard let self else { return }

            do {
                let response = try await repository.fetchPlaces(
                    query: DiningListQuery(
                        latitude: currentCoordinate.latitude,
                        longitude: currentCoordinate.longitude,
                        category: category.serverKey
                    )
                )
                guard !Task.isCancelled else { return }
                let restaurants = response.places.map(NearDiningCellItem.init(dto:))
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

    @MainActor
    func updateMapMarkers(from restaurants: [NearDiningCellItem]) {
        var markers: [CompanionMapMarkerData] = []

        for restaurant in restaurants {
            if let marker = CompanionMapMarkerData(diningItem: restaurant) {
                markers.append(marker)
            }
        }

        output.mapMarkers.send(markers)
    }

    func updateFavorite(at index: Int) {
        let restaurants = output.restaurants.value
        guard
            restaurants.indices.contains(index),
            let placeId = restaurants[index].placeId,
            favoriteTasks[placeId] == nil
        else { return }

        let isFavorite = !restaurants[index].isBookmarked
        updateFavorite(placeId: placeId, isFavorite: isFavorite)
        favoriteTasks[placeId] = Task { [weak self] in
            guard let self else { return }
            defer { favoriteTasks[placeId] = nil }

            do {
                let response = try await repository.updateFavorite(
                    placeId: placeId,
                    isFavorite: isFavorite
                )
                guard !Task.isCancelled else { return }
                updateFavorite(placeId: placeId, isFavorite: response.isFavorite)
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                updateFavorite(placeId: placeId, isFavorite: !isFavorite)
                output.error.send(error)
            }
        }
    }
}
