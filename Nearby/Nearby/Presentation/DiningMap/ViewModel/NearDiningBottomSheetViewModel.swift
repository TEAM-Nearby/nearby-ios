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

    // MARK: - View State

    enum ViewState {
        case idle
        case loading
        case loaded(items: [NearDiningCellItem], markers: [CompanionMapMarkerData])
        case failed(Error)
    }

    // MARK: - Output

    struct Output {
        let selectedCategory = CurrentValueSubject<DiningCategory, Never>(.restaurant)
        let viewState = CurrentValueSubject<ViewState, Never>(.idle)
        let selectedRestaurant = PassthroughSubject<NearDiningCellItem, Never>()
    }
    
    // MARK: - Properties

    let output = Output()

    private let repository: DiningMapRepository
    private var restaurants: [NearDiningCellItem] = []
    private var currentCoordinate: CLLocationCoordinate2D?
    private var fetchTask: Task<Void, Never>?
    private var favoriteTasks: [Int: Task<Void, Never>] = [:]

    var restaurantCount: Int { restaurants.count }

    // MARK: - Initializer
    
    init(repository: DiningMapRepository) {
        self.repository = repository
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
            guard restaurants.indices.contains(index) else { return }
            output.selectedRestaurant.send(restaurant(at: index))
        case .bookmarkDidTap(let index):
            updateFavorite(at: index)
        }
    }

    // MARK: - Methods
    
    func restaurant(at index: Int) -> NearDiningCellItem {
        restaurants[index]
    }

    func restaurant(placeId: Int) -> NearDiningCellItem? {
        restaurants.first { $0.placeId == placeId }
    }

    func updateFavorite(placeId: Int, isFavorite: Bool) {
        guard let index = restaurants.firstIndex(where: { $0.placeId == placeId }) else { return }
        restaurants[index].isBookmarked = isFavorite
        publishRestaurants()
    }

    private func fetchRestaurants() {
        guard let currentCoordinate else { return }

        fetchTask?.cancel()
        let category = output.selectedCategory.value
        output.viewState.send(.loading)

        fetchTask = Task { [weak self] in
            guard let self else { return }

            do {
                let places = try await repository.fetchPlaces(
                    criteria: DiningPlaceSearchCriteria(
                        latitude: currentCoordinate.latitude,
                        longitude: currentCoordinate.longitude,
                        category: category.diningPlaceCategory
                    )
                )
                guard !Task.isCancelled else { return }
                restaurants = places.map(NearDiningCellItem.init(place:))
                publishRestaurants()
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                output.viewState.send(.failed(error))
            }
        }
    }

    private func updateFavorite(at index: Int) {
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
                let updatedFavorite = try await repository.updateFavorite(placeId: placeId, isFavorite: isFavorite)
                guard !Task.isCancelled else { return }
                updateFavorite(placeId: placeId, isFavorite: updatedFavorite)
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                updateFavorite(placeId: placeId, isFavorite: !isFavorite)
                output.viewState.send(.failed(error))
            }
        }
    }

    private func publishRestaurants() {
        let markers = restaurants.compactMap { CompanionMapMarkerData(diningItem: $0) }
        output.viewState.send(.loaded(items: restaurants, markers: markers))
    }
}
