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
        let viewController = diContainer.makeMatchingViewController(coordinator: self)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }

    func showScheduleDetail(item: MatchingMatchedCardItem) {
        let viewController = diContainer.makeMatchingScheduleDetailViewController(
            coordinator: self,
            item: item
        )
        navigationController.pushViewController(viewController, animated: true)
    }

    func showManageScheduleDetail(item: MatchingMatchedCardItem) {
        let viewController = diContainer.makeMatchingManageScheduleDetailViewController(
            coordinator: self,
            item: item
        )
        navigationController.pushViewController(viewController, animated: true)
    }

    func showAlarm() {
        let viewController = diContainer.makeAlarmViewController()
        viewController.hidesBottomBarWhenPushed = true
        viewController.onBackButtonDidTap = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    func showCompanionTab() {
        (parentCoordinator as? MainTabCoordinator)?.switchTab(to: .companion)
    }
}
