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

extension NotificationCoordinator {
    func handle(_ route: AlarmViewController.Route) {
        switch route {
        case .previous:
            navigationController.popViewController(animated: true)
        case .companionRequestAccept(let applicationId):
            showCompanionRequestAccept(applicationId: applicationId)
        case .companionRequestDecline:
            showCompanionRequestDecline()
        case .hostRequestReceive(let applicationId):
            showHostRequestReceive(applicationId: applicationId)
        case .schedule(let matchId):
            showMatchingScheduleDetail(matchId: matchId)
        }
    }
}

private extension NotificationCoordinator {
    func handle(_ route: NotificationRoute) {
        switch route {
        case .previous:
            navigationController.popViewController(animated: true)
        case .companionTab:
            showCompanionTab()
        case .scheduleDetail(let matchId):
            showMatchingScheduleDetail(matchId: matchId)
        case .recruitCompanion:
            showRecruitCompanion()
        case .manageSchedule(let matchId):
            showMatchingManageDetail(matchId: matchId)
        case .hostRequestDecline(let applicantName, let applicationId):
            showHostRequestDecline(applicantName: applicantName, applicationId: applicationId)
        case let .hostRequestAllow(applicantName, imageURL, locationName, meetingAt, matchId, postType, openChatURL):
            showHostRequestAllow(applicantName: applicantName, applicantProfileImageUrl: imageURL, locationName: locationName, meetingAt: meetingAt, matchId: matchId, postType: postType, openChatUrl: openChatURL)
        case .applicantProfile(let profileId):
            showHostProfile(profileId: profileId)
        }
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
        diContainer.myPage.makeAlarmViewController(initialTab: initialTab) { [weak self] route in
            self?.handle(route)
        }
    }
}

extension NotificationCoordinator {
    func showCompanionRequestSent(hostName: String) {
        let viewController = diContainer.notification.makeCompanionRequestSentViewController(hostName: hostName) { [weak self] route in
            self?.handle(route)
        }

        if let rootViewController = navigationController.viewControllers.first {
            navigationController.setViewControllers([rootViewController, viewController], animated: true)
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    func showCompanionRequestAccept(applicationId: Int) {
        let viewController = diContainer.notification.makeCompanionRequestAcceptViewController(applicationId: applicationId) { [weak self] route in
            self?.handle(route)
        }
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    func showCompanionRequestDecline() {
        let viewController = diContainer.notification.makeCompanionRequestDeclineViewController { [weak self] route in
            self?.handle(route)
        }
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension NotificationCoordinator {
    func showHostRequestReceive(applicationId: Int) {
        let viewController = diContainer.notification.makeHostRequestReceiveViewController(applicationId: applicationId) { [weak self] route in
            self?.handle(route)
        }

        viewController.hidesBottomBarWhenPushed = true

        navigationController.pushViewController(viewController, animated: true)
    }

    func showHostRequestAllow(applicantName: String, applicantProfileImageUrl: String?,
                              locationName: String, meetingAt: String,
                              matchId: Int?, postType: PostType,
                              openChatUrl: String
    ) {
        let viewController = diContainer.notification.makeHostRequestAllowViewController(
            applicantName: applicantName,
            applicantProfileImageUrl: applicantProfileImageUrl,
            locationName: locationName,
            meetingAt: meetingAt,
            matchId: matchId,
            postType: postType,
            openChatUrl: openChatUrl,
            onRoute: { [weak self] route in self?.handle(route) }
        )

        navigationController.pushViewController(viewController, animated: true)
    }

    func showHostRequestDecline(applicantName: String, applicationId: Int) {
        let viewController = diContainer.notification.makeHostRequestDeclineViewController(applicantName: applicantName, applicationId: applicationId) { [weak self] route in
            self?.handle(route)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension NotificationCoordinator {
    func showCompanionTab() {
        navigationController.popToRootViewController(animated: false)
        (navigationController.viewControllers.first as? CompanionViewController)?.resetToInitialState()
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

    func showMatchingTab() {
        navigationController.popToRootViewController(animated: false)
        mainTabCoordinator?.switchTab(to: .matching)
    }

    func showRecruitCompanion() {
        let companionCoordinator = diContainer.makeCompanionCoordinator(navigationController: navigationController)
        companionCoordinator.parentCoordinator = self
        addChildCoordinator(companionCoordinator)

        let viewController = diContainer.recruitCompanion.makeRecruitCompanionViewController { [weak companionCoordinator] route in
            switch route {
            case .previous: companionCoordinator?.showPrevious()
            }
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension NotificationCoordinator {
    func showMatchingScheduleDetail(matchId: Int) {
        let matchingCoordinator = makeChildMatchingCoordinator()
        matchingCoordinator.showScheduleDetail(matchId: matchId)
    }

    func showMatchingScheduleDetail(item: MatchingMatchedCardItem) {
        showMatchingScheduleDetail(matchId: item.matchId)
    }

    func showMatchingManageDetail(matchId: Int) {
        let matchingCoordinator = makeChildMatchingCoordinator()
        matchingCoordinator.showManageScheduleDetail(matchId: matchId)
    }

    func showMatchingManageDetail(item: MatchingMatchedCardItem) {
        showMatchingManageDetail(matchId: item.matchId)
    }
    
    func showHostProfile(profileId: Int) {
        let viewController = diContainer.notification.makeHostProfileViewController(profileId: profileId) { [weak self] route in
            self?.handle(route)
        }
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
