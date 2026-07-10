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

    // MARK: - Initializer

    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
}

// MARK: - Coordinator

extension MyPageCoordinator: Coordinator {
    func start() {
        let myPageViewController =
            appDIContainer.makeMyPageViewController()

        myPageViewController.onAlarmButtonDidTap = { [weak self] in
            self?.showAlarm()
        }

        myPageViewController.onSettingButtonDidTap = { [weak self] in
            self?.showSetting()
        }

        navigationController.setViewControllers(
            [myPageViewController],
            animated: false
        )
    }

    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}

// MARK: - Private Methods

private extension MyPageCoordinator {
    func showAlarm() {
        let alarmViewController =
            appDIContainer.makeAlarmViewController()

        alarmViewController.hidesBottomBarWhenPushed = true

        alarmViewController.onBackButtonDidTap = { [weak self] in
            self?.navigationController.popViewController(
                animated: true
            )
        }

        navigationController.pushViewController(
            alarmViewController,
            animated: true
        )
    }

    func showSetting() {
        let settingViewController =
            appDIContainer.makeSettingViewController()

        settingViewController.hidesBottomBarWhenPushed = true

        settingViewController.onBackButtonDidTap = { [weak self] in
            self?.navigationController.popViewController(
                animated: true
            )
        }

        settingViewController.onLogoutButtonDidTap = { [weak self] in
            self?.onLogoutDidFinish?()
        }

        navigationController.pushViewController(
            settingViewController,
            animated: true
        )
    }
}
