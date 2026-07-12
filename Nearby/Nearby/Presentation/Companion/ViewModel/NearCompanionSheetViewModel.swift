//
//  NearCompanionSheetViewModel.swift
//  Nearby
//
//  Created by soomin on 7/9/26.
//

import Combine
import CoreLocation

final class NearCompanionSheetViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case locationDidUpdate(CLLocationCoordinate2D)
        case placeCategoryDidSelect(String)
        case sortOptionDidTap(SortOption)
        case companionDidSelect(Int)
    }

    // MARK: - Output

    struct Output {
        let sortOptions: [SortOption]
        let selectedSortOption = CurrentValueSubject<SortOption, Never>(.latest)
        let companions = CurrentValueSubject<[NearCompanionCellItem], Never>([])
        let mapMarkers = CurrentValueSubject<[CompanionMapMarkerData], Never>([])
        let summaryText = PassthroughSubject<String, Never>()
        let selectedCompanion = PassthroughSubject<NearCompanionCellItem, Never>()
        let error = PassthroughSubject<Error, Never>()
    }

    // MARK: - Properties

    let output = Output(sortOptions: SortOption.allCases)

    var nearCompanionCount: Int {
        output.companions.value.count
    }

    private let repository: CompanionRepository
    private var currentCoordinate: CLLocationCoordinate2D?
    private var placeCategory = "RESTAURANT"
    private var fetchTask: Task<Void, Never>?

    // MARK: - Initializer

    init(repository: CompanionRepository) {
        self.repository = repository
    }

    deinit {
        fetchTask?.cancel()
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .locationDidUpdate(let coordinate):
            currentCoordinate = coordinate
            fetchPosts()

        case .placeCategoryDidSelect(let category):
            placeCategory = category
            fetchPosts()

        case .sortOptionDidTap(let option):
            output.selectedSortOption.send(option)
            fetchPosts()

        case .companionDidSelect(let index):
            guard output.companions.value.indices.contains(index) else { return }
            output.selectedCompanion.send(companion(at: index))
        }
    }
    
    // MARK: - Method

    func companion(at index: Int) -> NearCompanionCellItem {
        output.companions.value[index]
    }
}

private extension NearCompanionSheetViewModel {
    func fetchPosts() {
        guard let currentCoordinate else { return }

        fetchTask?.cancel()
        let sort = output.selectedSortOption.value

        fetchTask = Task { [weak self] in
            guard let self else { return }

            do {
                let response = try await repository.fetchList(
                    query: CompanionListQuery(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude,
                                              radiusMeters: 1_000, placeCategory: placeCategory, sort: sort.serverKey)
                )
                guard !Task.isCancelled else { return }

                output.companions.send(response.posts.map(NearCompanionCellItem.init(dto:)))
                output.mapMarkers.send(response.posts.map(CompanionMapMarkerData.init(dto:)))
                output.summaryText.send(response.summaryText)
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                output.error.send(error)
            }
        }
    }
}
