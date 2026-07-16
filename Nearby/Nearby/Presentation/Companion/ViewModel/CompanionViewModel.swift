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

    // MARK: - Route

    enum Route {
        case recruitCompanion
        case companionDetail(CompanionDetailState)
    }

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case recruitCompanionButtonDidTap
        case companionDidSelect(CompanionDetailState)
    }

    // MARK: - Output

    struct Output {
        let categoryItems: [CategoryItem]
        let mapConfiguration: CompanionMapConfiguration
        let nickname = PassthroughSubject<String, Never>()
    }

    // MARK: - Properties

    var route: ((Route) -> Void)?
    var output: Output

    private let myPageRepository: MyPageRepository
    private var nicknameTask: Task<Void, Never>?

    // MARK: - Initializer

    init(
        myPageRepository: MyPageRepository,
        categoryItems: [CategoryItem] = CategoryItem.categoryItems,
        mapConfiguration: CompanionMapConfiguration = .mock
    ) {
        self.myPageRepository = myPageRepository
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
            fetchNickname()
        case .recruitCompanionButtonDidTap:
            route?(.recruitCompanion)
        case .companionDidSelect(let state):
            route?(.companionDetail(state))
        }
    }
}

private extension CompanionViewModel {
    func fetchNickname() {
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
