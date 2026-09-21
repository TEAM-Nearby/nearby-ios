//
//  NearCompanionSheetViewModel.swift
//  Nearby
//
//  Created by soomin on 7/9/26.
//

import Combine
import CoreLocation

final class NearCompanionSheetViewModel: BaseViewModelType {

    // MARK: - State

    enum ViewState {
        case idle
        case loading
        case loaded(items: [NearCompanionCellItem], markers: [CompanionMapMarkerData], summaryText: String)
        case failed(Error)
    }

    // MARK: - Input

    enum Input {
        case locationDidUpdate(CLLocationCoordinate2D)
        case placeCategoryDidSelect(CompanionPlace.Category)
        case sortOptionDidTap(SortOption)
        case companionDidSelect(Int)
    }

    // MARK: - Output

    struct Output {
        let sortOptions: [SortOption]
        let selectedSortOption = CurrentValueSubject<SortOption, Never>(.latest)
        let viewState = CurrentValueSubject<ViewState, Never>(.idle)
        let selectedCompanion = PassthroughSubject<NearCompanionCellItem, Never>()
    }

    // MARK: - Properties

    let output = Output(sortOptions: SortOption.allCases)

    var nearCompanionCount: Int {
        companions.count
    }

    private let repository: CompanionRepository
    private var currentCoordinate: CLLocationCoordinate2D?
    private var placeCategory: CompanionPlace.Category = .restaurant
    private var fetchTask: Task<Void, Never>?
    private var postsByPlaceId: [Int: [CompanionPost]] = [:]
    private var companions: [NearCompanionCellItem] = []

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
            guard companions.indices.contains(index) else { return }
            output.selectedCompanion.send(companion(at: index))
        }
    }

    // MARK: - Custom Methods

    func companion(at index: Int) -> NearCompanionCellItem {
        companions[index]
    }

    @MainActor
    func specificCompanions(for placeId: Int) -> [SpecificCompanionCellItem] {
        (postsByPlaceId[placeId] ?? []).map(SpecificCompanionCellItem.init(post:))
    }

    // MARK: - Private Method

    private func fetchPosts() {
        guard let currentCoordinate else { return }

        fetchTask?.cancel()
        let sort = output.selectedSortOption.value
        output.viewState.send(.loading)

        fetchTask = Task { [weak self] in
            guard let self else { return }

            do {
                let criteria = CompanionSearchCriteria(latitude: currentCoordinate.latitude,
                                                       longitude: currentCoordinate.longitude,
                                                       radiusMeters: 1_000, placeCategory: placeCategory,
                                                       sort: sort.companionSort)
                let response = try await repository.fetchList(criteria: criteria)
                guard !Task.isCancelled else { return }

                postsByPlaceId = Dictionary(grouping: response.posts, by: { $0.place.placeId })
                let latestPostsByPlace = postsByPlaceId.values.compactMap { posts in
                    posts.max { ($0.createdAt ?? .distantPast) < ($1.createdAt ?? .distantPast) }
                }

                companions = response.posts.map(NearCompanionCellItem.init(post:))
                output.viewState.send(.loaded(items: companions,
                                              markers: latestPostsByPlace.map(CompanionMapMarkerData.init(post:)),
                                              summaryText: response.summaryText))
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                output.viewState.send(.failed(error))
            }
        }
    }
}
