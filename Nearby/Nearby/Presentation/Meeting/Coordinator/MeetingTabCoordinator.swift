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
    
    private weak var reportReturnViewController: UIViewController?
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
}

// MARK: - Coordinator

extension MeetingTabCoordinator: Coordinator {
    func start() {
        let viewController = diContainer.makeMeetingViewController(coordinator: self)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
    
    func showMeetingProgress(for item: MeetingItem) {
        let viewController = diContainer.makeMeetingProgressViewController(
            coordinator: self,
            meetingId: item.id
        )
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showReview(type: NearbyUserType, item: ReviewItem) {
        let viewController = diContainer.makeReviewViewController(
            coordinator: self, type: type, reviewItem: item
        )
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showHostReviewList() {
        let viewController = diContainer.makeHostReviewListViewController(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showReviewPost(for item: ReviewItem, type: NearbyUserType, isLast: Bool, onSaved: (() -> Void)?) {
        let viewController = diContainer.makeReviewPostViewController(
            coordinator: self, reviewItem: item, type: type, isLast: isLast, onSaved: onSaved
        )
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showReportPost() {
        reportReturnViewController = navigationController.topViewController
        let viewController = diContainer.makeReportPostViewController(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showReportComplete() {
        let viewController = diContainer.makeReportCompletionViewController(coordinator: self)
        viewController.navigationItem.hidesBackButton = true
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func dismissReportFlow() {
        if let target = reportReturnViewController {
            navigationController.popToViewController(target, animated: true)
        } else {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func popReportPost() {
        navigationController.popViewController(animated: true)
    }
    
    func finishCompanionReview() {
        navigationController.popToRootViewController(animated: false)
        (parentCoordinator as? MainTabCoordinator)?.switchTab(to: .companion)
    }
    
    func showCompanionTab() {
        (parentCoordinator as? MainTabCoordinator)?.switchTab(to: .companion)
    }
    
    func showNotification() {
        let notificationCoordinator = makeChildNotificationCoordinator()
        notificationCoordinator.start()
    }
    
    private func makeChildNotificationCoordinator() -> NotificationCoordinator {
        let notificationCoordinator = diContainer.makeNotificationCoordinator(navigationController: navigationController)
        notificationCoordinator.parentCoordinator = self
        addChildCoordinator(notificationCoordinator)
        return notificationCoordinator
    }
}
