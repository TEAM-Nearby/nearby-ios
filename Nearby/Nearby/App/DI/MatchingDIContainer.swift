//
//  MatchingDIContainer.swift
//  Nearby
//
//  Created by soomin on 9/9/26.
//

import UIKit

final class MatchingDIContainer {
    
    // MARK: - Dependencies

    private let matchingRepository: MatchedCompanionListRepository
    private let eventCenter: MeetingEventCenter

    // MARK: - Initializer

    init(repository: MatchedCompanionListRepository, eventCenter: MeetingEventCenter) {
        self.matchingRepository = repository
        self.eventCenter = eventCenter
    }

    // MARK: - Factory Methods

    func makeMatchingViewController(onRoute: @escaping (MatchingRoute) -> Void
    ) -> UIViewController {
        let viewModel = MatchingViewModel(
            repository: matchingRepository,
            eventCenter: eventCenter
        )
        let viewController = MatchingViewController(viewModel: viewModel)
        viewController.onRoute = onRoute
        return viewController
    }

    func makeScheduleDetailViewController(matchId: Int, onRoute: @escaping (MatchingRoute) -> Void
    ) -> UIViewController {
        let viewModel = MatchingScheduleDetailViewModel(matchId: matchId, repository: matchingRepository)
        let viewController = MatchingScheduleDetailViewController(viewModel: viewModel)
        viewController.onRoute = onRoute
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeManageScheduleDetailViewController(matchId: Int, onRoute: @escaping (MatchingRoute) -> Void
    ) -> UIViewController {
        let viewModel = MatchingManageDetailViewModel(matchId: matchId, repository: matchingRepository)
        let viewController = MatchingManageDetailViewController(viewModel: viewModel)
        viewController.onRoute = onRoute
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
}
