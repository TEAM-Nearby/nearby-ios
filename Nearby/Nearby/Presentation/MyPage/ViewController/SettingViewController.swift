//
//  SettingViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/10/26.
//

import UIKit

final class SettingViewController: BaseViewController<SettingViewModel> {

    // MARK: - Properties

    var onBackButtonDidTap: (() -> Void)?
    var onLogoutButtonDidTap: (() -> Void)?

    // MARK: - UI Component

    private let settingView = SettingView()

    // MARK: - Life Cycles

    override func loadView() {
        view = settingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Custom Method

    override func setAddTarget() {
        settingView.navigationBar.leftButtonAction = { [weak self] in
            self?.viewModel.action(.backButtonDidTap)
        }

        settingView.logoutButton.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)
    }
}

// MARK: - Private Method

private extension SettingViewController {
    func bindViewModel() {
        viewModel.output.backButtonDidTap = { [weak self] in
            self?.onBackButtonDidTap?()
        }

        viewModel.output.logoutButtonDidTap = { [weak self] in
            self?.onLogoutButtonDidTap?()
        }

        viewModel.output.logoutErrorMessage = { [weak self] message in
            self?.showLogoutErrorAlert(message: message)
        }

        viewModel.output.isLogoutLoading = { [weak self] isLoading in
            self?.settingView.logoutButton.isEnabled = !isLoading
        }
    }

    func showLogoutErrorAlert(message: String) {
        guard presentedViewController == nil else { return }

        let alertController = UIAlertController(
            title: "로그아웃 실패",
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "확인", style: .default))
        present(alertController, animated: true)
    }
}

// MARK: - Action

private extension SettingViewController {
    @objc
    func logoutButtonDidTap() {
        viewModel.action(.logoutButtonDidTap)
    }
}
