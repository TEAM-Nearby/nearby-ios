//
//  NorificationCoordinator.swift
//  Nearby
//
//  Created by h2e on 7/11/26.
//

import UIKit

final class NotificationCoordinator {
    
    // MARK: - Properties
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    private let navigationController: UINavigationController
    private let diContainer: AppDIContainer
    
    private weak var reportReturnViewController: UIViewController?
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
}

// MARK: - Coordinator

extension NotificationCoordinator: Coordinator {
    func start() {
//        let viewController = diContainer.makeAlarmViewController()(coordinator: self)
//        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
    
    func showCompanionTab() {
        (parentCoordinator as? MainTabCoordinator)?.switchTab(to: .companion)
    }
    
    func showRecruitCompanion() {
        let viewController = diContainer.makeRecruitCompanionViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showMeetingList() {
        (parentCoordinator as? MainTabCoordinator)?.switchTab(to: .meeting)
    }
}
