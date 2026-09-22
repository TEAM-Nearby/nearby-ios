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
    private weak var hostReviewListViewController: HostReviewListViewController?
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
}

// MARK: - Coordinator

extension MeetingTabCoordinator: Coordinator {
    func start() {
        let viewController = diContainer.meeting.makeMeetingViewController { [weak self] route in
            self?.handle(route)
        }
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
    
    private func makeChildNotificationCoordinator() -> NotificationCoordinator {
        let notificationCoordinator = diContainer.makeNotificationCoordinator(navigationController: navigationController)
        notificationCoordinator.parentCoordinator = self
        childCoordinators.removeAll { $0 is NotificationCoordinator }
        addChildCoordinator(notificationCoordinator)
        return notificationCoordinator
    }
    
    func showMeetingProgress(for item: MeetingItem) {
        let viewController = diContainer.meeting.makeMeetingProgressViewController(item: item) { [weak self] route in
            self?.handle(route)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showReview(type: NearbyUserType, item: ReviewItem) {
        switch type {
        case .host:
            showHostReviewList(meetingId: item.meetingId)
        case .participant:
            showReviewPost(for: item, type: type, isLast: false, onSaved: nil)
        }
    }
    
    func showHostReviewList(meetingId: Int) {
        let viewController = diContainer.meeting.makeHostReviewListViewController(meetingId: meetingId) { [weak self] route in
            self?.handle(route)
        }
        hostReviewListViewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showReviewPost(for item: ReviewItem, type: NearbyUserType, isLast: Bool, onSaved: (() -> Void)?) {
        let viewController = diContainer.meeting.makeReviewPostViewController(reviewItem: item, type: type, isLast: isLast, onSaved: onSaved) { [weak self] route in
            self?.handle(route)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showReportPost() {
        reportReturnViewController = navigationController.topViewController
        let viewController = diContainer.meeting.makeReportPostViewController { [weak self] route in
            self?.handle(route)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showReportComplete() {
        let viewController = diContainer.meeting.makeReportCompletionViewController { [weak self] route in
            self?.handle(route)
        }
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
    
    func finishCompanionReview() {
        navigationController.popToRootViewController(animated: false)
        (parentCoordinator as? MainTabCoordinator)?.switchTab(to: .companion)
    }
    
    func showCompanionTab() {
        (parentCoordinator as? MainTabCoordinator)?.switchTab(to: .companion)
    }
    
    func showNotification() {
        let notificationCoordinator = makeChildNotificationCoordinator()
        notificationCoordinator.showAlarm()
    }
    
    // MARK: - Alert

    func showCheckInSuccessAlert() {
        presentAlert(title: "만남이 인증되었습니다.")
    }

    func showErrorAlert(message: String) {
        presentAlert(message: message)
    }

    private func presentAlert(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        navigationController.present(alert, animated: true)
    }
}

private extension MeetingTabCoordinator {
    func handle(_ route: MeetingRoute) {
        switch route {
        case .notification:
            showNotification()
        case .companionTab:
            showCompanionTab()
        case .progress(let item):
            showMeetingProgress(for: item)
        case .previous:
            navigationController.popViewController(animated: true)
        case .report:
            showReportPost()
        case .reportCompletion:
            showReportComplete()
        case .dismissReport:
            dismissReportFlow()
        case .participantReview(let item):
            showReview(type: .participant, item: item)
        case .hostReviewList(let meetingId):
            showHostReviewList(meetingId: meetingId)
        case .hostReview(let item, let isLast):
            showReviewPost(for: item, type: .host, isLast: isLast) { [weak self] in
                self?.hostReviewListViewController?.reviewDidSave(item)
            }
        case .reviewCompletion:
            finishCompanionReview()
        case .checkInSuccess:
            showCheckInSuccessAlert()
        case .error(let message):
            showErrorAlert(message: message)
        }
    }
}
