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
        let viewController = diContainer.makeRecruitCompanionViewController(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showPrevious() {
        if let notificationCoordinator = parentCoordinator as? NotificationCoordinator {
            notificationCoordinator.showCompanionTab()
            return
        }

        navigationController.popViewController(animated: true)
    }

    private func handle(_ route: CompanionDetailViewModel.Route) {
        switch route {
        case .close:
            navigationController.popViewController(animated: true)
        case .applyCompanion(let hostName):
            showCompanionRequestSent(hostName: hostName)
        case .hostProfile(let profileId):
            showHostProfile(profileId: profileId)
        }
    }

    private func showHostProfile(profileId: Int) {
        let viewController = diContainer.makeHostProfileViewController(profileId: profileId)
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showCompanionRequestSent(hostName: String) {
        makeNotificationCoordinator().showCompanionRequestSent(hostName: hostName)
    }

    private func showAlarm() {
        makeNotificationCoordinator().showAlarm()
    }

    private func makeNotificationCoordinator() -> NotificationCoordinator {
        let coordinator = diContainer.makeNotificationCoordinator(
            navigationController: navigationController
        )
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        return coordinator
    }

    func showCompanionDetail(state: CompanionDetailState) {
        let viewModel = diContainer.makeCompanionDetailViewModel(state: state)
        viewModel.route = { [weak self] route in
            self?.handle(route)
        }

        let viewController = diContainer.makeCompanionDetailViewController(viewModel: viewModel)
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
        companionViewController.onAlarmButtonDidTap = { [weak self] in
            self?.showAlarm()
        }
        navigationController.setViewControllers([companionViewController], animated: false)
    }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}
