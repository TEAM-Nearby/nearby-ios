//
//  CompanionCoordinator.swift
//  Nearby
//
//  Created by soomin on 7/7/26.
//

import UIKit

final class CompanionCoordinator {
    
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
    
    // MARK: - Methods
    
    private func handle(_ route: CompanionViewModel.Route) {
        switch route {
        case .recruitCompanion:
            showRecruitCompanion()
        }
    }
    
    private func showRecruitCompanion() {
        // TODO: 동행글 작성 View로 이동
//        let viewController = diContainer.makeRecruitCompanionViewController()
//        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - Coordinator

extension CompanionCoordinator: Coordinator {
    func start() {
        let viewModel = diContainer.makeCompanionViewModel()
        viewModel.route = { [weak self] route in
            self?.handle(route)
        }
        
        let viewController = diContainer.makeCompanionViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}
