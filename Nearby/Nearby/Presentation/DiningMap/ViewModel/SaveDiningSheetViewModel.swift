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
    
    var diningFavoriteSort: DiningFavoriteSort {
        switch self {
        case .latest: .latest
        case .oldest: .oldest
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
    
    // MARK: - View State
    
    enum ViewState {
        case idle
        case loading
        case loaded(items: [NearDiningCellItem], totalCount: Int, markers: [CompanionMapMarkerData])
        case failed(Error)
    }
    
    // MARK: - Output
    
    struct Output {
        let selectedCategory = CurrentValueSubject<DiningCategory, Never>(.restaurant)
        let selectedSort = CurrentValueSubject<DiningFavoriteSortOption, Never>(.latest)
        let viewState = CurrentValueSubject<ViewState, Never>(.idle)
        let selectedRestaurant = PassthroughSubject<NearDiningCellItem, Never>()
        let favoriteDidUpdate = PassthroughSubject<(placeId: Int, isFavorite: Bool), Never>()
    }
    
    // MARK: - Properties
    
    let output = Output()
    
    private let repository: DiningMapRepository
    private var restaurants: [NearDiningCellItem] = []
    private var totalCount = 0
    private var currentCoordinate: CLLocationCoordinate2D?
    private var fetchTask: Task<Void, Never>?
    private var favoriteTasks: [Int: Task<Void, Never>] = [:]
    
    var restaurantCount: Int { restaurants.count }
    var mapMarkers: [CompanionMapMarkerData] {
        restaurants.compactMap { CompanionMapMarkerData(diningItem: $0, style: .savedRestaurant) }
    }
    
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
            guard restaurants.indices.contains(index) else { return }
            output.selectedRestaurant.send(restaurant(at: index))
        case .bookmarkDidTap(let index):
            removeFavorite(at: index)
        }
    }
    
    // MARK: - Methods
    
    private func fetchFavorites() {
        guard let currentCoordinate else { return }
        
        fetchTask?.cancel()
        let category = output.selectedCategory.value
        let sort = output.selectedSort.value
        output.viewState.send(.loading)
        
        fetchTask = Task { [weak self] in
            guard let self else { return }
            
            do {
                let favoriteList = try await repository.fetchFavorites(
                    criteria: DiningFavoritesCriteria(latitude: currentCoordinate.latitude,
                                                      longitude: currentCoordinate.longitude,
                                                      category: category.diningPlaceCategory,
                                                      sort: sort.diningFavoriteSort))
                guard !Task.isCancelled else { return }
                restaurants = await favoriteRestaurants(from: favoriteList.places, coordinate: currentCoordinate)
                guard !Task.isCancelled else { return }
                totalCount = favoriteList.totalCount
                publishRestaurants()
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                output.viewState.send(.failed(error))
            }
        }
    }
    
    private func removeFavorite(at index: Int) {
        guard
            restaurants.indices.contains(index),
            let placeId = restaurants[index].placeId,
            favoriteTasks[placeId] == nil
        else { return }
        
        favoriteTasks[placeId] = Task { [weak self] in
            guard let self else { return }
            defer { favoriteTasks[placeId] = nil }
            
            do {
                let isFavorite = try await repository.updateFavorite(placeId: placeId, isFavorite: false)
                guard !Task.isCancelled else { return }
                removeRestaurant(placeId: placeId)
                output.favoriteDidUpdate.send((placeId, isFavorite))
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                output.viewState.send(.failed(error))
            }
        }
    }
    
    private func removeRestaurant(placeId: Int) {
        guard let index = restaurants.firstIndex(where: { $0.placeId == placeId }) else { return }
        restaurants.remove(at: index)
        totalCount = max(0, totalCount - 1)
        publishRestaurants()
    }
    
    private func favoriteRestaurants(from favorites: [DiningPlace], coordinate: CLLocationCoordinate2D) async -> [NearDiningCellItem] {
        var items = favorites.map { favorite in
            restaurants.first { $0.placeId == favorite.placeId } ?? NearDiningCellItem(place: favorite)
        }
        
        await withTaskGroup(of: (Int, DiningPlace?).self) { group in
            for (index, favorite) in favorites.enumerated() {
                group.addTask { [repository] in
                    let place = try? await repository.fetchPlaceDetail(
                        criteria: DiningPlaceDetailCriteria(placeId: favorite.placeId,
                                                            latitude: coordinate.latitude,
                                                            longitude: coordinate.longitude))
                    return (index, place)
                }
            }
            
            for await (index, place) in group {
                guard let place else { continue }
                items[index] = NearDiningCellItem(place: place)
            }
        }
        
        return items
    }
    
    private func publishRestaurants() {
        output.viewState.send(.loaded(items: restaurants, totalCount: totalCount, markers: mapMarkers))
    }
    
    func restaurant(at index: Int) -> NearDiningCellItem {
        restaurants[index]
    }
    
    func restaurant(placeId: Int) -> NearDiningCellItem? {
        restaurants.first { $0.placeId == placeId }
    }
    
    func updateFavorite(placeId: Int, isFavorite: Bool) {
        guard !isFavorite else { return }
        removeRestaurant(placeId: placeId)
    }
}
