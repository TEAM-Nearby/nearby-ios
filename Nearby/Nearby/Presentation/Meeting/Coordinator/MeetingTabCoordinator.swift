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
    
    func start() {
        // TODO: - 확인용 임시 코드, 확인 후 원복
            let viewModel = CompanionRequestAcceptViewModel(
                hostName: "정지영",
                locationName: "시우다드 콘달"
            )
            let viewController = CompanionRequestAcceptViewController(viewModel: viewModel)
            navigationController.setViewControllers([viewController], animated: false)
            
            // 원래 코드 (확인 후 복구)
            // let viewController = diContainer.makeMeetingViewController(coordinator: self)
            // navigationController.setViewControllers([viewController], animated: false)
        }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
    
    func showMeetingProgress(for item: MeetingItem) {
        let viewController = diContainer.makeMeetingProgressViewController(
            coordinator: self,
            item: item
        )
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showHostReviewList() {
        let viewController = diContainer.makeHostReviewListViewController(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showReviewPost(for item: ReviewItem) {
        let viewController = diContainer.makeReviewPostViewController(coordinator: self, reviewItem: item)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showReportPost() {
        let viewController = diContainer.makeReportPostViewController(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showReportComplete() {
        let viewController = diContainer.makeReportCompletionViewController(coordinator: self)
        viewController.navigationItem.hidesBackButton = true
        navigationController.pushViewController(viewController, animated: true)
    }

    func dismissReportFlow() {
        navigationController.popToRootViewController(animated: true)
    }
}
