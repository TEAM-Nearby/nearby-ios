//
//  MeetingTabCoordinator.swift
//  Nearby
//
//  Created by h2e on 7/8/26.
//

import UIKit

final class MeetingTabCoordinator {
    
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

extension MeetingTabCoordinator: Coordinator {
    
    // MARK: - Coordinator
    
    func start() {
        let viewController = diContainer.makeMeetingViewController(coordinator: self)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
    
    func showVerification() {
        // TODO: - 만남 인증 화면 연결
    }
}
