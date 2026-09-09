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

    func makeMatchingViewController(coordinator: MatchingCoordinator) -> UIViewController {
        let viewController = MatchingViewController(viewModel: MatchingViewModel(repository: matchingRepository, eventCenter: eventCenter))
        viewController.coordinator = coordinator
        return viewController
    }

    func makeScheduleDetailViewController(coordinator: MatchingCoordinator, matchId: Int) -> UIViewController {
        let viewController = MatchingScheduleDetailViewController(viewModel: MatchingScheduleDetailViewModel(matchId: matchId, repository: matchingRepository))
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeManageScheduleDetailViewController(coordinator: MatchingCoordinator, displayData: MatchingScheduleDetailDisplayData) -> UIViewController {
        let viewController = MatchingManageDetailViewController(displayData: displayData, repository: matchingRepository)
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeManageScheduleDetailViewController(coordinator: MatchingCoordinator, matchId: Int) -> UIViewController {
        let viewController = MatchingManageDetailViewController(matchId: matchId, repository: matchingRepository)
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
}
