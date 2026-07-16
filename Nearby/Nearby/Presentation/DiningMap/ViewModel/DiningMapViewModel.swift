//
//  DiningMapViewModel.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import Combine
import CoreLocation

final class DiningMapViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case bookmarkDidTap
    }

    // MARK: - Output
    
    struct Output {
        let mapConfiguration: CompanionMapConfiguration
        let isBookmarkSelected = CurrentValueSubject<Bool, Never>(false)
        let nickname = PassthroughSubject<String, Never>()
    }
    
    // MARK: - Property

    let output: Output

    private let myPageRepository: MyPageRepository
    private var nicknameTask: Task<Void, Never>?

    // MARK: - Initializer
    
    init(
        myPageRepository: MyPageRepository,
        mapConfiguration: CompanionMapConfiguration = .diningMap
    ) {
        self.myPageRepository = myPageRepository
        self.output = Output(mapConfiguration: mapConfiguration)
    }

    deinit {
        nicknameTask?.cancel()
    }

    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchNickname()
        case .bookmarkDidTap:
            output.isBookmarkSelected.send(!output.isBookmarkSelected.value)
        }
    }
}

private extension DiningMapViewModel {
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
    static let diningMap = CompanionMapConfiguration(
        referenceCoordinate: CLLocationCoordinate2D(latitude: 41.3879706, longitude: 2.1671360),
        initialZoom: 16.2,
        smallMarkerMaximumZoom: -1,
        largeMarkerMinimumZoom: 100,
        mediumMarkerSize: 24,
        smallMarkerSize: 10,
        markerItems: []
    )
}
