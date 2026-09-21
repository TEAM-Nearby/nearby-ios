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

    struct CategoryState {
        let selectedIndex: Int?
        let previousIndex: Int?
        let content: CategoryContent

        var shouldShowCompanionMarkers: Bool {
            if case .companions = content { return true }
            return false
        }
    }

    enum CategoryContent {
        case companions(CompanionPlace.Category)
        case empty
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
        case recruitCompanionButtonDidTap
        case companionDidSelect(CompanionDetailState)
    }

    // MARK: - Output

    struct Output {
        let categoryItems: [CategoryItem]
        let mapConfiguration: CompanionMapConfiguration
        let nickname = PassthroughSubject<String, Never>()
        let categoryState = CurrentValueSubject<CategoryState, Never>(
            CategoryState(selectedIndex: 0, previousIndex: nil, content: .companions(.restaurant))
        )
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
                output.nickname.send(initialNickname)
            } else {
                fetchNickname()
            }
        case .categoryDidSelect(let index):
            updateCategory(at: index)
        case .recruitCompanionButtonDidTap:
            route?(.recruitCompanion)
        case .companionDidSelect(let state):
            route?(.companionDetail(state))
        }
    }

    // MARK: - Private Methods

    private func updateCategory(at index: Int) {
        guard output.categoryItems.indices.contains(index) else { return }

        let previousIndex = output.categoryState.value.selectedIndex
        let selectedIndex = previousIndex == index ? nil : index
        let category = output.categoryItems[index]
        let content: CategoryContent = selectedIndex == nil || category.isRestaurant
                                    ? .companions(.restaurant) : .empty

        output.categoryState.send(CategoryState(selectedIndex: selectedIndex, previousIndex: previousIndex, content: content))
    }

    private func fetchNickname() {
        nicknameTask?.cancel()
        nicknameTask = Task { [weak self] in
            guard let self else { return }

            do {
                let response = try await myPageRepository.fetchMyPage()
                guard !Task.isCancelled else { return }
                output.nickname.send(response.nickname)
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
        smallMarkerSize: 10,
        markerItems: []
    )
}
