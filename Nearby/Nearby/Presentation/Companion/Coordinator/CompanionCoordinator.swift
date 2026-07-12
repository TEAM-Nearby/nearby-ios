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
        case .companionDetail(let state):
            showCompanionDetail(state: state)
        }
    }
    
    private func showRecruitCompanion() {
        let viewController = diContainer.makeRecruitCompanionViewController()
        navigationController.pushViewController(viewController, animated: true)
    }

    private func handle(_ route: CompanionDetailViewModel.Route) {
        switch route {
        case .close:
            navigationController.popViewController(animated: true)
        case .applyCompanion:
            // TODO: 동행 신청 API 성공 후 다음 화면 연결
            break
        }
    }

    func showCompanionDetail(state: CompanionDetailState) {
        let viewModel = diContainer.makeCompanionDetailViewModel(state: state)
        viewModel.route = { [weak self] route in
            self?.handle(route)
        }

        let viewController = diContainer.makeCompanionDetailViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - Coordinator

extension CompanionCoordinator: Coordinator {
    func start() {
        let viewModel = diContainer.makeCompanionViewModel()
        viewModel.route = { [weak self] route in
            self?.handle(route)
        }
        
        let companionViewController = diContainer.makeCompanionViewController(viewModel: viewModel)
        navigationController.setViewControllers([companionViewController], animated: false)
    }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}
