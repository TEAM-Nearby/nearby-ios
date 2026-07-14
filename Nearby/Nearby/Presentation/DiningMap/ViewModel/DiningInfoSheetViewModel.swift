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
    
    // MARK: - Output

    struct Output {
        let restaurant = CurrentValueSubject<NearDiningCellItem?, Never>(nil)
        let favoriteDidUpdate = PassthroughSubject<(placeId: Int, isFavorite: Bool), Never>()
        let error = PassthroughSubject<Error, Never>()
    }
    
    // MARK: - Propeties

    let output = Output()

    private let repository: DiningMapRepository
    private let coordinate: CLLocationCoordinate2D
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
            output.restaurant.send(item)
            fetchDetail(placeId: item.placeId)
        case .bookmarkDidTap:
            updateFavorite()
        }
    }
}

private extension DiningInfoSheetViewModel {
    func fetchDetail(placeId: Int?) {
        guard let placeId else { return }

        fetchTask?.cancel()
        fetchTask = Task { [weak self] in
            guard let self else { return }

            do {
                let response = try await repository.fetchPlaceDetail(
                    query: DiningDetailQuery(
                        placeId: placeId,
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude
                    )
                )
                guard !Task.isCancelled else { return }
                var item = NearDiningCellItem(dto: response)
                if let favoriteOverride {
                    item.isBookmarked = favoriteOverride
                }
                output.restaurant.send(item)
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                output.error.send(error)
            }
        }
    }

    func updateFavorite() {
        guard
            favoriteTask == nil,
            let item = output.restaurant.value,
            let placeId = item.placeId
        else { return }

        let isFavorite = !item.isBookmarked
        favoriteOverride = isFavorite
        var updatedItem = item
        updatedItem.isBookmarked = isFavorite
        output.restaurant.send(updatedItem)

        favoriteTask = Task { [weak self] in
            guard let self else { return }
            defer { favoriteTask = nil }

            do {
                let response = try await repository.updateFavorite(
                    placeId: placeId,
                    isFavorite: isFavorite
                )
                guard
                    !Task.isCancelled,
                    var updatedItem = output.restaurant.value,
                    updatedItem.placeId == placeId
                else { return }
                favoriteOverride = response.isFavorite
                updatedItem.isBookmarked = response.isFavorite
                output.restaurant.send(updatedItem)
                output.favoriteDidUpdate.send((placeId, response.isFavorite))
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                if var revertedItem = output.restaurant.value,
                   revertedItem.placeId == placeId {
                    favoriteOverride = !isFavorite
                    revertedItem.isBookmarked = !isFavorite
                    output.restaurant.send(revertedItem)
                }
                output.error.send(error)
            }
        }
    }
}
