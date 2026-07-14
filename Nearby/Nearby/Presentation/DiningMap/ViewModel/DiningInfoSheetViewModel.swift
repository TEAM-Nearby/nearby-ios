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
        let bookmarkDidTap = PassthroughSubject<Void, Never>()
        let error = PassthroughSubject<Error, Never>()
    }
    
    // MARK: - Propeties

    let output = Output()

    private let repository: DiningMapRepository
    private let coordinate: CLLocationCoordinate2D
    private var fetchTask: Task<Void, Never>?

    // MARK: - Initializer

    init(repository: DiningMapRepository, coordinate: CLLocationCoordinate2D) {
        self.repository = repository
        self.coordinate = coordinate
    }

    deinit {
        fetchTask?.cancel()
    }
    
    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .updateRestaurant(let item):
            output.restaurant.send(item)
            fetchDetail(placeId: item.placeId)
        case .bookmarkDidTap:
            guard var item = output.restaurant.value else { return }
            item.isBookmarked.toggle()
            output.restaurant.send(item)
            output.bookmarkDidTap.send(())
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
                output.restaurant.send(NearDiningCellItem(dto: response))
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                output.error.send(error)
            }
        }
    }
}
