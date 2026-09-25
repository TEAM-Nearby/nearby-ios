//
//  DiningInfoSheetViewModel.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

import Combine
import CoreLocation

final class DiningInfoSheetViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case updateRestaurant(NearDiningCellItem)
        case bookmarkDidTap
    }
    
    // MARK: - View State
    
    enum ViewState {
        case idle
        case loading(NearDiningCellItem)
        case loaded(NearDiningCellItem)
        case failed(Error)
    }
    
    // MARK: - Output
    
    struct Output {
        let viewState = CurrentValueSubject<ViewState, Never>(.idle)
        let favoriteDidUpdate = PassthroughSubject<(placeId: Int, isFavorite: Bool), Never>()
    }
    
    // MARK: - Properties
    
    let output = Output()
    
    private let repository: DiningMapRepository
    private let coordinate: CLLocationCoordinate2D
    private var restaurant: NearDiningCellItem?
    private var fetchTask: Task<Void, Never>?
    private var favoriteTask: Task<Void, Never>?
    private var favoriteOverride: Bool?
    
    // MARK: - Initializer
    
    init(repository: DiningMapRepository, coordinate: CLLocationCoordinate2D) {
        self.repository = repository
        self.coordinate = coordinate
    }
    
    deinit {
        fetchTask?.cancel()
        favoriteTask?.cancel()
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .updateRestaurant(let item):
            favoriteTask?.cancel()
            favoriteTask = nil
            favoriteOverride = nil
            restaurant = item
            output.viewState.send(.loading(item))
            fetchDetail(placeId: item.placeId)
        case .bookmarkDidTap:
            updateFavorite()
        }
    }
    
    // MARK: - Methods
    
    private func fetchDetail(placeId: Int?) {
        guard let placeId else {
            if let restaurant {
                output.viewState.send(.loaded(restaurant))
            }
            return
        }
        
        fetchTask?.cancel()
        fetchTask = Task { [weak self] in
            guard let self else { return }
            
            do {
                let place = try await repository.fetchPlaceDetail(
                    criteria: DiningPlaceDetailCriteria(
                        placeId: placeId,
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude
                    )
                )
                guard !Task.isCancelled else { return }
                var item = NearDiningCellItem(place: place)
                if let favoriteOverride {
                    item.isBookmarked = favoriteOverride
                }
                restaurant = item
                output.viewState.send(.loaded(item))
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                output.viewState.send(.failed(error))
            }
        }
    }
    
    private func updateFavorite() {
        guard favoriteTask == nil, var item = restaurant, let placeId = item.placeId else { return }
        
        let isFavorite = !item.isBookmarked
        favoriteOverride = isFavorite
        item.isBookmarked = isFavorite
        restaurant = item
        output.viewState.send(.loaded(item))
        
        favoriteTask = Task { [weak self] in
            guard let self else { return }
            defer { favoriteTask = nil }
            
            do {
                let updatedFavorite = try await repository.updateFavorite(placeId: placeId, isFavorite: isFavorite)
                guard !Task.isCancelled, var item = restaurant, item.placeId == placeId else { return }
                favoriteOverride = updatedFavorite
                item.isBookmarked = updatedFavorite
                restaurant = item
                output.viewState.send(.loaded(item))
                output.favoriteDidUpdate.send((placeId, updatedFavorite))
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                if var item = restaurant, item.placeId == placeId {
                    favoriteOverride = !isFavorite
                    item.isBookmarked = !isFavorite
                    restaurant = item
                    output.viewState.send(.loaded(item))
                }
                output.viewState.send(.failed(error))
            }
        }
    }
}
