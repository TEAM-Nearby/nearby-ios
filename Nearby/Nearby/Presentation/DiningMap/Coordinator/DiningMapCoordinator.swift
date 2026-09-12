//
//  DiningMapCoordinator.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import UIKit

final class DiningMapCoordinator {
    
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

    private func showAlarm() {
        let coordinator = diContainer.makeNotificationCoordinator(
            navigationController: navigationController
        )
        coordinator.parentCoordinator = parentCoordinator
        parentCoordinator?.addChildCoordinator(coordinator)
        coordinator.showAlarm()
    }
}

// MARK: - Coordinator

extension DiningMapCoordinator: Coordinator {
    func start() {
        let viewController = diContainer.diningMap.makeDiningMapViewController()
        viewController.onAlarmButtonDidTap = { [weak self] in
            self?.showAlarm()
        }
        navigationController.setViewControllers([viewController], animated: false)
    }

    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}
