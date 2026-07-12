//
//  MyPageCoordinator.swift
//  Nearby
//
//  Created by 신서연 on 7/10/26.
//

import UIKit

final class MyPageCoordinator {

    // MARK: - Properties

    weak var parentCoordinator: Coordinator?

    var childCoordinators = [Coordinator]()

    private let navigationController: UINavigationController

    private let appDIContainer: AppDIContainer

    var onLogoutDidFinish: (() -> Void)?
    var onFindCompanionDidTap: (() -> Void)?

    // MARK: - Initializer

    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
}

// MARK: - Coordinator

extension MyPageCoordinator: Coordinator {
    func start() {
        let myPageViewController = appDIContainer.makeMyPageViewController()

        myPageViewController.onAlarmButtonDidTap = { [weak self] in
            self?.showAlarm()
        }

        myPageViewController.onSettingButtonDidTap = { [weak self] in
            self?.showSetting()
        }

        myPageViewController.onWrittenPostRowDidTap = { [weak self] in
            self?.showWrittenPost()
        }

        myPageViewController.onSentRequestRowDidTap = { [weak self] in
            self?.showAlarm(initialTab: .sent)
        }

        myPageViewController.onReceivedRequestRowDidTap = { [weak self] in
            self?.showAlarm(initialTab: .received)
        }

        navigationController.setViewControllers([myPageViewController], animated: false)
    }

    func finish() {parentCoordinator?.removeChildCoordinator(self)}
}

// MARK: - Coordinator

private extension MyPageCoordinator {
    func showAlarm(initialTab: AlarmTab = .sent) {
        let alarmViewController = appDIContainer.makeAlarmViewController(initialTab: initialTab)

        alarmViewController.hidesBottomBarWhenPushed = true

        alarmViewController.onBackButtonDidTap = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }

        alarmViewController.onRequestActionDidTap = { [weak self] requestItem in
            guard let self else { return }

            switch requestItem.displayType {
            case .sentAccepted:
                showCompanionRequestAccept(hostName: requestItem.nickname)

            case .sentRejected:
                showCompanionRequestDecline()

            case .receivedPending:
                showHostRequestRecieve(applicantName: requestItem.nickname)
            }
        }

        navigationController.pushViewController(alarmViewController, animated: true)
    }

    func showSetting() {
        let settingViewController = appDIContainer.makeSettingViewController()

        settingViewController.hidesBottomBarWhenPushed = true

        settingViewController.onBackButtonDidTap = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }

        settingViewController.onLogoutButtonDidTap = {[weak self] in
            self?.onLogoutDidFinish?()
        }

        navigationController.pushViewController(settingViewController, animated: true)
    }

    func showWrittenPost() {
        let writtenPostViewController = appDIContainer.makeWrittenPostViewController()

        writtenPostViewController.hidesBottomBarWhenPushed = true

        writtenPostViewController.onBackButtonDidTap = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }

        writtenPostViewController.onFindCompanionButtonDidTap = { [weak self] in
            guard let self else { return }

            navigationController.popToRootViewController(animated: false)
            onFindCompanionDidTap?()
        }

        navigationController.pushViewController(writtenPostViewController, animated: true)
    }
    
    func showCompanionRequestAccept(hostName: String) {
        let notificationCoordinator = appDIContainer.makeNotificationCoordinator(navigationController: navigationController)

        notificationCoordinator.parentCoordinator = self

        addChildCoordinator(notificationCoordinator)

        notificationCoordinator.showCompanionRequestAccept(hostName: hostName, locationName: "시우다드 콘달")
    }
    
    func showCompanionRequestDecline() {
        let notificationCoordinator = appDIContainer.makeNotificationCoordinator(navigationController: navigationController)

        notificationCoordinator.parentCoordinator = self

        addChildCoordinator(notificationCoordinator)

        notificationCoordinator.showCompanionRequestDecline()
    }
    
    func showHostRequestRecieve(applicantName: String) {
        let notificationCoordinator =
            appDIContainer.makeNotificationCoordinator(navigationController: navigationController)

        notificationCoordinator.parentCoordinator = self

        addChildCoordinator(notificationCoordinator)

        notificationCoordinator.showHostRequestRecieve(applicantName: applicantName, locationName: "시우다드 콘달")
    }
}
