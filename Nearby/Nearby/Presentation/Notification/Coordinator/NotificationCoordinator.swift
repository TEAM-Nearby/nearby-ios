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
        let alarmViewController = makeAlarmViewController()

        navigationController.setViewControllers([alarmViewController], animated: false)
    }

    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }

    func showAlarm(initialTab: AlarmTab = .sent) {
        let alarmViewController = makeAlarmViewController(initialTab: initialTab)
        alarmViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(alarmViewController, animated: true)
    }

    private func makeAlarmViewController(initialTab: AlarmTab = .sent) -> AlarmViewController {
        let alarmViewController = diContainer.makeAlarmViewController(
            initialTab: initialTab
        )
        alarmViewController.coordinator = self

        alarmViewController.onBackButtonDidTap = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }

        alarmViewController.onRequestActionDidTap = { [weak self] requestItem in
            guard let self else { return }
            switch requestItem.displayType {
            case .sentAccepted:
                showCompanionRequestAccept(applicationId: requestItem.applicationId)
            case .sentRejected:
                showCompanionRequestDecline()

            case .receivedPending:
                showHostRequestRecieve(applicationId: requestItem.applicationId)
            default:
                break
            }
        }

        return alarmViewController
    }
}

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
}

extension NotificationCoordinator {
    func showHostRequestRecieve(applicationId: Int) {
        let viewController = diContainer.makeHostRequestRecieveViewController(coordinator: self, applicationId: applicationId)

        viewController.hidesBottomBarWhenPushed = true

        navigationController.pushViewController(viewController, animated: true)
    }

    func showHostRequestAllow(applicantName: String, applicantProfileImageUrl: String?,
                              locationName: String, meetingAt: String,
                              matchId: Int?, postType: PostType,
                              openChatUrl: String
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
        )

        navigationController.pushViewController(viewController, animated: true)
    }

    func showHostRequestDecline(applicantName: String, applicationId: Int) {
        let viewController = diContainer.makeHostRequestDeclineViewController(coordinator: self, applicantName: applicantName, applicationId: applicationId)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension NotificationCoordinator {
    func showCompanionTab() {
        navigationController.popToRootViewController(animated: false)
        mainTabCoordinator?.switchTab(to: .companion)
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
        navigationController.popToRootViewController(animated: false)
        mainTabCoordinator?.switchTab(to: .meeting)
    }

    func showRecruitCompanion() {
        let companionCoordinator = diContainer.makeCompanionCoordinator(navigationController: navigationController)
        companionCoordinator.parentCoordinator = self
        addChildCoordinator(companionCoordinator)

        let viewController = diContainer.makeRecruitCompanionViewController(coordinator: companionCoordinator)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension NotificationCoordinator {
    func showMatchingScheduleDetail(matchId: Int) {
        let matchingCoordinator = makeChildMatchingCoordinator()
        let viewController = diContainer.makeMatchingScheduleDetailViewController(
            coordinator: matchingCoordinator,
            matchId: matchId
        )
        navigationController.pushViewController(viewController, animated: true)
    }

    func showMatchingScheduleDetail(item: MatchingMatchedCardItem) {
        showMatchingScheduleDetail(matchId: item.matchId)
    }

    func showMatchingManageDetail(matchId: Int) {
        let matchingCoordinator = makeChildMatchingCoordinator()
        let viewController = diContainer.makeMatchingManageScheduleDetailViewController(
            coordinator: matchingCoordinator,
            matchId: matchId
        )
        navigationController.pushViewController(viewController, animated: true)
    }

    func showMatchingManageDetail(item: MatchingMatchedCardItem) {
        showMatchingManageDetail(matchId: item.matchId)
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
