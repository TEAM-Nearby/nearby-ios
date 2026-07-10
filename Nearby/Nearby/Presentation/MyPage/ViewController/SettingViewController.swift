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
        settingView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
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
    }
}

// MARK: - Actions

private extension SettingViewController {
    @objc func backButtonDidTap() {
        viewModel.action(.backButtonDidTap)
    }
    
    @objc func logoutButtonDidTap() {
        viewModel.action(.logoutButtonDidTap)
    }
}
