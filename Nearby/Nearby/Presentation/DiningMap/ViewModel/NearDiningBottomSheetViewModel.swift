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

    private let repository: DiningRepository
    private var currentCoordinate: CLLocationCoordinate2D?
    private var fetchTask: Task<Void, Never>?

    var restaurantCount: Int { output.restaurants.value.count }

    // MARK: - Initializer
    
    init(repository: DiningRepository) {
        self.repository = repository
        output = Output(restaurants: CurrentValueSubject([]))
    }

    deinit {
        fetchTask?.cancel()
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
            var restaurants = output.restaurants.value
            restaurants[index].isBookmarked.toggle()
            output.restaurants.send(restaurants)
            updateMapMarkers(from: restaurants)
        }
    }

    // MARK: - Methods
    
    func restaurant(at index: Int) -> NearDiningCellItem {
        output.restaurants.value[index]
    }

    func restaurant(placeId: Int) -> NearDiningCellItem? {
        output.restaurants.value.first { $0.placeId == placeId }
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

    func updateMapMarkers(from restaurants: [NearDiningCellItem]) {
        output.mapMarkers.send(restaurants.compactMap(CompanionMapMarkerData.init(diningItem:)))
    }
}
