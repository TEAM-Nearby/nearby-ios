//
//  CompanionViewModel.swift
//  Nearby
//
//  Created by soomin on 7/6/26.
//

import CoreFoundation
import Combine
import CoreLocation

final class CompanionViewModel: BaseViewModelType {

    // MARK: - State

    struct ViewState: Equatable {
        var nickname: String?
        var category: CategoryState
        var bottomSheet: BottomSheetState
        var selectedPlaceId: Int?
    }

    struct CategoryState: Equatable {
        let selectedIndex: Int?
        let previousIndex: Int?
        let content: CategoryContent

        var shouldShowCompanionMarkers: Bool {
            if case .companions = content { return true }
            return false
        }
    }

    enum CategoryContent: Equatable {
        case companions(CompanionPlace.Category)
        case empty

        var shouldShowCompanions: Bool {
            if case .companions = self { return true }
            return false
        }
    }

    enum ViewEvent {
        case moveToCurrentLocation
    }

    // MARK: - Route

    enum Route {
        case recruitCompanion
        case companionDetail(CompanionDetailState)
    }

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case categoryDidSelect(Int)
        case markerDidSelect(Int)
        case bottomSheetDidChange(BottomSheetState)
        case specificSheetDidClose
        case currentLocationButtonDidTap
        case reset
        case recruitCompanionButtonDidTap
        case companionDidSelect(CompanionDetailState)
    }

    // MARK: - Output

    struct Output {
        let categoryItems: [CategoryItem]
        let mapConfiguration: CompanionMapConfiguration
        let viewState = CurrentValueSubject<ViewState, Never>(
            ViewState(nickname: nil, category: CategoryState(selectedIndex: 0, previousIndex: nil, content: .companions(.restaurant)),
                      bottomSheet: BottomSheetState(content: .nearbyCompanionList), selectedPlaceId: nil)
        )
        let event = PassthroughSubject<ViewEvent, Never>()
    }

    // MARK: - Properties

    var route: ((Route) -> Void)?
    var output: Output

    private let myPageRepository: MyPageRepository
    private let initialNickname: String?
    private var nicknameTask: Task<Void, Never>?

    // MARK: - Initializer

    init(
        myPageRepository: MyPageRepository,
        initialNickname: String? = nil,
        categoryItems: [CategoryItem] = CategoryItem.categoryItems,
        mapConfiguration: CompanionMapConfiguration = .mock
    ) {
        self.myPageRepository = myPageRepository
        self.initialNickname = initialNickname
        self.output = Output(
            categoryItems: categoryItems,
            mapConfiguration: mapConfiguration
        )
    }

    deinit {
        nicknameTask?.cancel()
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            if let initialNickname {
                updateNickname(initialNickname)
            } else {
                fetchNickname()
            }
        case .categoryDidSelect(let index):
            updateCategory(at: index)
        case .markerDidSelect(let placeId):
            updateSelectedPlace(placeId)
        case .bottomSheetDidChange(let bottomSheet):
            updateBottomSheet(bottomSheet)
        case .specificSheetDidClose:
            updateBottomSheet(BottomSheetState(content: .nearbyCompanionList), selectedPlaceId: nil)
        case .currentLocationButtonDidTap:
            output.event.send(.moveToCurrentLocation)
        case .reset:
            updateBottomSheet(BottomSheetState(content: .nearbyCompanionList, level: .compact), selectedPlaceId: nil)
        case .recruitCompanionButtonDidTap:
            route?(.recruitCompanion)
        case .companionDidSelect(let state):
            route?(.companionDetail(state))
        }
    }

    // MARK: - Methods

    private func updateCategory(at index: Int) {
        guard output.categoryItems.indices.contains(index) else { return }

        var viewState = output.viewState.value
        let previousIndex = viewState.category.selectedIndex
        let selectedIndex = previousIndex == index ? nil : index
        let category = output.categoryItems[index]
        let content: CategoryContent = selectedIndex == nil || category.isRestaurant ? .companions(.restaurant) : .empty
        let bottomSheetContent: BottomSheetContent = content.shouldShowCompanions ? .nearbyCompanionList : .nearbyCompanionEmpty

        viewState.category = CategoryState(selectedIndex: selectedIndex, previousIndex: previousIndex, content: content)
        viewState.bottomSheet = BottomSheetState(content: bottomSheetContent)
        viewState.selectedPlaceId = nil
        output.viewState.send(viewState)
    }

    private func updateNickname(_ nickname: String) {
        var viewState = output.viewState.value
        viewState.nickname = nickname
        output.viewState.send(viewState)
    }

    private func updateSelectedPlace(_ placeId: Int) {
        var viewState = output.viewState.value
        viewState.selectedPlaceId = placeId
        viewState.bottomSheet = BottomSheetState(content: .specificRestaurantCompanionList)
        output.viewState.send(viewState)
    }

    private func updateBottomSheet(_ bottomSheet: BottomSheetState) {
        var viewState = output.viewState.value
        guard viewState.bottomSheet != bottomSheet else { return }

        viewState.bottomSheet = bottomSheet
        output.viewState.send(viewState)
    }

    private func updateBottomSheet(_ bottomSheet: BottomSheetState, selectedPlaceId: Int?) {
        var viewState = output.viewState.value
        guard viewState.bottomSheet != bottomSheet || viewState.selectedPlaceId != selectedPlaceId else { return }

        viewState.bottomSheet = bottomSheet
        viewState.selectedPlaceId = selectedPlaceId
        output.viewState.send(viewState)
    }

    private func fetchNickname() {
        nicknameTask?.cancel()
        nicknameTask = Task { [weak self] in
            guard let self else { return }

            do {
                let response = try await myPageRepository.fetchMyPage()
                guard !Task.isCancelled else { return }
                updateNickname(response.nickname)
            } catch {
                guard !Task.isCancelled else { return }
                AppLogger.error(error)
            }
        }
    }
}

private extension CompanionMapConfiguration {
    static let mock = CompanionMapConfiguration(
        referenceCoordinate: CLLocationCoordinate2D(latitude: 41.3879706, longitude: 2.1671360),
        initialZoom: 16.2,
        smallMarkerMaximumZoom: 14.0,
        largeMarkerMinimumZoom: 15.6,
        mediumMarkerSize: 24,
        smallMarkerSize: 10
    )
}
