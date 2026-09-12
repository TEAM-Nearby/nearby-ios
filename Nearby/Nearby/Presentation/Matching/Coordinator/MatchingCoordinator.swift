//
//  MatchingCoordinator.swift
//  Nearby
//
//  Created by 장지인 on 7/11/26.
//

import UIKit

final class MatchingCoordinator {

    // MARK: - Properties

    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    private let navigationController: UINavigationController
    private let diContainer: AppDIContainer

    // MARK: - Initializer

    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
}

// MARK: - Coordinator

extension MatchingCoordinator: Coordinator {
    func start() {
        let viewController = diContainer.matching.makeMatchingViewController(coordinator: self)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }

    func showScheduleDetail(matchId: Int) {
        let viewController = diContainer.matching.makeScheduleDetailViewController(
            coordinator: self,
            matchId: matchId
        )
        navigationController.pushViewController(viewController, animated: true)
    }

    func showManageScheduleDetail(displayData: MatchingScheduleDetailDisplayData) {
        let viewController = diContainer.matching.makeManageScheduleDetailViewController(
            coordinator: self,
            displayData: displayData
        )
        navigationController.pushViewController(viewController, animated: true)
    }

    func showPrevious() {
        if let notificationCoordinator = parentCoordinator as? NotificationCoordinator {
            notificationCoordinator.showMatchingTab()
            return
        }

        navigationController.popViewController(animated: true)
    }

    func showAlarm() {
        let notificationCoordinator = diContainer.makeNotificationCoordinator(
            navigationController: navigationController
        )
        notificationCoordinator.parentCoordinator = self
        addChildCoordinator(notificationCoordinator)
        notificationCoordinator.showAlarm()
    }

    func showCompanionTab() {
        (parentCoordinator as? MainTabCoordinator)?.switchTab(to: .companion)
    }
}
