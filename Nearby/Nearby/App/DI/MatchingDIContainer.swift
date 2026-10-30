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
    private let notificationRepository: CompanionRequestRepository
    private let eventCenter: MeetingEventCenter

    // MARK: - Initializer

    init(networkProvider: NetworkProvider, repository: MatchedCompanionListRepository, eventCenter: MeetingEventCenter) {
        self.matchingRepository = repository
        let notificationService = DefaultCompanionRequestService(networkProvider: networkProvider)
        self.notificationRepository = DefaultCompanionRequestRepository(service: notificationService)
        self.eventCenter = eventCenter
    }

    // MARK: - Factory Methods

    func makeMatchingViewController(isGuest: Bool = false, onRoute: @escaping (MatchingRoute) -> Void) -> UIViewController {
        let viewModel = MatchingViewModel(repository: matchingRepository, notificationRepository: notificationRepository, eventCenter: eventCenter, isGuest: isGuest)
        let viewController = MatchingViewController(viewModel: viewModel)
        viewController.onRoute = onRoute
        return viewController
    }

    func makeScheduleDetailViewController(matchId: Int, onRoute: @escaping (MatchingRoute) -> Void) -> UIViewController {
        let viewModel = MatchingScheduleDetailViewModel(matchId: matchId, repository: matchingRepository)
        let viewController = MatchingScheduleDetailViewController(viewModel: viewModel)
        viewController.onRoute = onRoute
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeManageScheduleDetailViewController(matchId: Int, disablesSwipeBack: Bool = false, onRoute: @escaping (MatchingRoute) -> Void) -> UIViewController {
        let viewModel = MatchingManageDetailViewModel(matchId: matchId, repository: matchingRepository)
        let viewController = MatchingManageDetailViewController(viewModel: viewModel)
        viewController.onRoute = onRoute
        viewController.isSwipeBackDisabled = disablesSwipeBack
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
}
