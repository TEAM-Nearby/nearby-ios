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
        case recruitCompanion(CLLocationCoordinate2D?)
        case companionDetail(CompanionDetailState)
    }

    // MARK: - Input

    enum Input {
        case refreshNotifications
        case viewDidLoad
        case categoryDidSelect(Int)
        case markerDidSelect(Int)
        case bottomSheetDidChange(BottomSheetState)
        case specificSheetDidClose
        case currentLocationButtonDidTap
        case locationDidUpdate(CLLocationCoordinate2D)
        case reset
        case selectRestaurantCategory
        case recruitCompanionButtonDidTap
        case companionDidSelect(CompanionDetailState)
        case companionAvailabilityDidChange(Bool)
    }

    // MARK: - Output

    struct Output {
        let categoryItems: [CategoryItem]
        let mapConfiguration: CompanionMapConfiguration
        let viewState = CurrentValueSubject<ViewState, Never>(
            ViewState(nickname: nil, category: CategoryState(selectedIndex: 0, previousIndex: nil, content: .companions(.restaurant)),
                      bottomSheet: BottomSheetState(content: .nearbyCompanionList), selectedPlaceId: nil)
        )
        let hasUnreadNotifications = CurrentValueSubject<Bool, Never>(false)
        let event = PassthroughSubject<ViewEvent, Never>()
    }

    // MARK: - Properties

    var route: ((Route) -> Void)?
    var output: Output

    private let isGuest: Bool
    private let notificationRepository: CompanionRequestRepository
    private var notificationTask: Task<Void, Never>?
    private let myPageRepository: MyPageRepository
    private let initialNickname: String?
    private var nicknameTask: Task<Void, Never>?
    private var currentCoordinate: CLLocationCoordinate2D?

    // MARK: - Initializer

    init(
        myPageRepository: MyPageRepository,
        notificationRepository: CompanionRequestRepository,
        isGuest: Bool = false,
        initialNickname: String? = nil,
        categoryItems: [CategoryItem] = CategoryItem.categoryItems,
        mapConfiguration: CompanionMapConfiguration = .mock
    ) {
        self.isGuest = isGuest
        self.notificationRepository = notificationRepository
        self.myPageRepository = myPageRepository
        self.initialNickname = initialNickname
        self.output = Output(
            categoryItems: categoryItems,
            mapConfiguration: mapConfiguration
        )
    }

    deinit {
        nicknameTask?.cancel()
        notificationTask?.cancel()
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .refreshNotifications:
            refreshNotifications()
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
        case .locationDidUpdate(let coordinate):
            currentCoordinate = coordinate
        case .reset:
            reset()
        case .selectRestaurantCategory:
            selectRestaurantCategory()
        case .recruitCompanionButtonDidTap:
            guard output.viewState.value.category.content.shouldShowCompanions else { return }
            route?(.recruitCompanion(currentCoordinate))
        case .companionDidSelect(let state):
            route?(.companionDetail(state))
        case .companionAvailabilityDidChange(let hasCompanions):
            updateCompanionAvailability(hasCompanions)
        }
    }

    // MARK: - Methods

    private func reset() {
        var viewState = output.viewState.value
        viewState.category = CategoryState(selectedIndex: 0, previousIndex: viewState.category.selectedIndex, content: .companions(.restaurant))
        viewState.bottomSheet = BottomSheetState(content: .nearbyCompanionList, level: .compact)
        viewState.selectedPlaceId = nil
        output.viewState.send(viewState)
    }

    private func selectRestaurantCategory() {
        var viewState = output.viewState.value
        viewState.category = CategoryState(selectedIndex: 0, previousIndex: viewState.category.selectedIndex, content: .companions(.restaurant))
        viewState.bottomSheet = BottomSheetState(content: .nearbyCompanionList, level: viewState.bottomSheet.level)
        viewState.selectedPlaceId = nil
        output.viewState.send(viewState)
    }

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

    private func updateCompanionAvailability(_ hasCompanions: Bool) {
        var viewState = output.viewState.value
        guard case .companions = viewState.category.content,
              viewState.bottomSheet.content != .specificRestaurantCompanionList else { return }

        let content: BottomSheetContent = hasCompanions ? .nearbyCompanionList : .nearbyCompanionEmpty
        guard viewState.bottomSheet.content != content else { return }

        viewState.bottomSheet = BottomSheetState(content: content)
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

    private func fetchUnreadNotifications(direction: CompanionRequestDirection) async -> Bool? {
        do {
            let response = try await notificationRepository.fetchRequests(direction: direction)
            guard !Task.isCancelled else { return nil }
            let hasUnread = response.requests.contains { !$0.isRead }
            if hasUnread {
                output.hasUnreadNotifications.send(true)
            }
            return hasUnread
        } catch {
            guard !Task.isCancelled else { return nil }
            AppLogger.error(error)
            return nil
        }
    }

    private func refreshNotifications() {
        guard !isGuest else { return }
        notificationTask?.cancel()
        notificationTask = Task { [weak self] in
            guard let self else { return }
            async let sent = fetchUnreadNotifications(direction: .sent)
            async let received = fetchUnreadNotifications(direction: .received)
            let results = await (sent, received)
            guard !Task.isCancelled else { return }
            if results.0 == false, results.1 == false {
                output.hasUnreadNotifications.send(false)
            }
        }
    }

    private func fetchNickname() {
        guard !isGuest else { return }
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
    static var developmentReferenceCoordinate: CLLocationCoordinate2D? {
#if DEBUG
        CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)
#else
        nil
#endif
    }

    static let mock = CompanionMapConfiguration(
        referenceCoordinate: developmentReferenceCoordinate,
        initialZoom: 16.2,
        smallMarkerMaximumZoom: 14.0,
        largeMarkerMinimumZoom: 15.6,
        mediumMarkerSize: 24,
        smallMarkerSize: 10
    )
}
