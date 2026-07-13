//
//  NotificationCoordinator.swift
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
        // TODO: - 서연 님 개발 후 구현
        showHostRequestAllow(applicantName: "장현준", locationName: "시우다드 콘달", postType: .scheduled)
//        let viewController = diContainer.makeAlarmViewController()(coordinator: self)
//        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
    
    func showCompanionRequestSent(hostName: String) {
        let viewController = diContainer.makeCompanionRequestSentViewController(
            coordinator: self,
            hostName: hostName
        )
        navigationController.pushViewController(viewController, animated: true)
    }

    func showCompanionRequestDecline() {
        let viewController = diContainer.makeCompanionRequestDeclineViewController(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showHostRequestDecline(applicantName: String) {
        let viewController = diContainer.makeHostRequestDeclineViewController(
            coordinator: self,
            applicantName: applicantName
        )
        navigationController.pushViewController(viewController, animated: true)
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
    
    func showMatchingScheduleDetail(item: MatchingMatchedCardItem) {
        let matchingCoordinator = makeChildMatchingCoordinator()
        let viewController = diContainer.makeMatchingScheduleDetailViewController(
            coordinator: matchingCoordinator,
            matchId: item.matchId
        )
        navigationController.pushViewController(viewController, animated: true)
    }

    func showMatchingManageDetail(item: MatchingMatchedCardItem) {
        let matchingCoordinator = makeChildMatchingCoordinator()
        let viewController = diContainer.makeMatchingManageScheduleDetailViewController(
            coordinator: matchingCoordinator,
            item: item
        )
        navigationController.pushViewController(viewController, animated: true)
    }

    private func makeChildMatchingCoordinator() -> MatchingCoordinator {
        let matchingCoordinator = diContainer.makeMatchingCoordinator(navigationController: navigationController)
        matchingCoordinator.parentCoordinator = self
        addChildCoordinator(matchingCoordinator)
        return matchingCoordinator
    }
    
    func showCompanionRequestAccept(hostName: String, locationName: String) {
        let viewController = diContainer.makeCompanionRequestAcceptViewController(
            coordinator: self,
            hostName: hostName,
            locationName: locationName
        )
        navigationController.pushViewController(viewController, animated: true)
    }

    func showHostRequestAllow(applicantName: String, locationName: String, postType: PostType) {
        let viewController = diContainer.makeHostRequestAllowViewController(
            coordinator: self,
            applicantName: applicantName,
            locationName: locationName,
            postType: postType
        )
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showHostRequestRecieve(applicantName: String, locationName: String) {
        let viewController = diContainer.makeHostRequestRecieveViewController(coordinator: self, applicantName: applicantName, locationName: locationName)

        viewController.hidesBottomBarWhenPushed = true

        navigationController.pushViewController(viewController, animated: true)
    }
}
