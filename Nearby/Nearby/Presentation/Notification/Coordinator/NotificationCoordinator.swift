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
        let alarmViewController = diContainer.makeAlarmViewController()
        alarmViewController.coordinator = self
        alarmViewController.onBackButtonDidTap = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }

        alarmViewController.onRequestActionDidTap = { [weak self] requestItem in
            guard let self else { return }
            switch requestItem.displayType {
            case .sentAccepted:
                // TODO: - 알림 API 연동
                showCompanionRequestAccept(applicationId: 6)
            case .sentRejected:
                showCompanionRequestDecline()
            case .receivedPending:
                // TODO: - 알림 API 연동
                showHostRequestRecieve(applicationId: 7)
            }
        }

        alarmViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(alarmViewController, animated: true)
    }

    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}

// MARK: - Companion Request 네비게이션

extension NotificationCoordinator {

    func showCompanionRequestSent(hostName: String) {
        let viewController = diContainer.makeCompanionRequestSentViewController(coordinator: self, hostName: hostName)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showCompanionRequestAccept(applicationId: Int) {
        let viewController = diContainer.makeCompanionRequestAcceptViewController(coordinator: self, applicationId: applicationId)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    func showCompanionRequestDecline() {
        let viewController = diContainer.makeCompanionRequestDeclineViewController(coordinator: self)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showHostRequestAllow(applicantName: String, applicantProfileImageUrl: String?, locationName: String, meetingAt: String, matchId: Int?, postType: PostType, openChatUrl: String) {
}

// MARK: - Host Request 네비게이션

extension NotificationCoordinator {

    func showHostRequestRecieve(applicationId: Int) {
        let viewController = diContainer.makeHostRequestRecieveViewController(coordinator: self, applicationId: applicationId)

        viewController.hidesBottomBarWhenPushed = true

        navigationController.pushViewController(viewController, animated: true)
    }

    func showHostRequestAllow(applicantName: String, applicantProfileImageUrl: String?,
                              locationName: String, meetingAt: String,
                              matchId: Int?, postType: PostType
    ) {
        let viewController = diContainer.makeHostRequestAllowViewController(
            coordinator: self,
            applicantName: applicantName,
            applicantProfileImageUrl: applicantProfileImageUrl,
            locationName: locationName,
            meetingAt: meetingAt,
            matchId: matchId,
            postType: postType,
            openChatUrl: openChatUrl
                             coordinator: self,
                             applicantName: applicantName,
                             applicantProfileImageUrl: applicantProfileImageUrl,
                             locationName: locationName,
                             meetingAt: meetingAt,
                             matchId: matchId,
                             postType: postType
        )

        navigationController.pushViewController(viewController, animated: true)
    }

    func showHostRequestDecline(applicantName: String, applicationId: Int) {
        let viewController = diContainer.makeHostRequestDeclineViewController(coordinator: self, applicantName: applicantName, applicationId: applicationId)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - Tab 네비게이션

extension NotificationCoordinator {

    func showCompanionTab() {
        navigationController.popToRootViewController(animated: false)
        mainTabCoordinator?.switchTab(to: .companion)
        guard let mainTabCoordinator = parentCoordinator as? MainTabCoordinator
        else {
            return
        }

        mainTabCoordinator.switchTab(to: .companion)
    }

    private var mainTabCoordinator: MainTabCoordinator? {
        var current = parentCoordinator
        while let coordinator = current {
            if let mainTabCoordinator = coordinator as? MainTabCoordinator {
                return mainTabCoordinator
            }
            current = coordinator.parentCoordinator
        }
        return nil
    }
    

    func showMeetingList() {
        guard let mainTabCoordinator = parentCoordinator as? MainTabCoordinator
        else {
            return
        }

        mainTabCoordinator.switchTab(to: .meeting)
    }

    func showRecruitCompanion() {
        let companionCoordinator = diContainer.makeCompanionCoordinator(navigationController: navigationController)
        companionCoordinator.parentCoordinator = self
        addChildCoordinator(companionCoordinator)

        let viewController = diContainer.makeRecruitCompanionViewController(coordinator: companionCoordinator)
        let viewController = diContainer.makeRecruitCompanionViewController()

        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showMeetingList() {
        navigationController.popToRootViewController(animated: false)
        mainTabCoordinator?.switchTab(to: .meeting)
    }
    
    func showMatchingScheduleDetail(matchId: Int) {
}

// MARK: - Matching 네비게이션

extension NotificationCoordinator {

    func showMatchingScheduleDetail(matchId: Int) {
        let matchingCoordinator = makeChildMatchingCoordinator()
        let viewController = diContainer.makeMatchingScheduleDetailViewController(
            coordinator: matchingCoordinator,
            matchId: matchId
        )
        let viewController = diContainer.makeMatchingScheduleDetailViewController(coordinator: matchingCoordinator, matchId: matchId)

        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showMatchingManageDetail(matchId: Int) {

    func showMatchingScheduleDetail(item: MatchingMatchedCardItem) {
        showMatchingScheduleDetail(matchId: item.matchId)
    }

    func showMatchingManageDetail(item: MatchingMatchedCardItem) {
        let matchingCoordinator = makeChildMatchingCoordinator()
        let viewController = diContainer.makeMatchingManageScheduleDetailViewController(
            coordinator: matchingCoordinator,
            matchId: matchId
        )
        let viewController = diContainer.makeMatchingManageScheduleDetailViewController(coordinator: matchingCoordinator, item: item)

        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showHostProfile(profileId: Int) {
        let viewController = diContainer.makeHostProfileViewController(profileId: profileId)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
    

    private func makeChildMatchingCoordinator() -> MatchingCoordinator {
        let matchingCoordinator = diContainer.makeMatchingCoordinator(navigationController: navigationController)
        matchingCoordinator.parentCoordinator = self
        addChildCoordinator(matchingCoordinator)

        return matchingCoordinator
    }
}
