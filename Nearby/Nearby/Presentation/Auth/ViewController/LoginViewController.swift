//
//  LoginViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/6/26.
//

import UIKit

final class LoginViewController: BaseViewController<LoginViewModel> {

    // MARK: - Properties

    var onGuestDidTap: (() -> Void)?
    var onLoginDidSucceed: ((OnboardingStatus) -> Void)?

    // MARK: - UI Component

    private let loginView = LoginView()

    // MARK: - Life Cycles

    override func loadView() {
        self.view = loginView
    }

    // MARK: - Custom Methods

    override func setAddTarget() {
        loginView.guestLoginButton.addTarget(self, action: #selector(guestButtonDidTap), for: .touchUpInside)
        loginView.kakaoLoginButton.addTarget(
            self, action: #selector(kakaoLoginButtonDidTap), for: .touchUpInside
        )
        
        loginView.appleLoginButton.addTarget(
            self, action: #selector(appleLoginButtonDidTap), for: .touchUpInside)
    }

    override func bindState() {
        viewModel.output.loginDidSucceed = { [weak self] onboardingStatus in
            self?.onLoginDidSucceed?(onboardingStatus)
        }

        viewModel.output.loginDidFail = { error in
            AppLogger.error(error, message: "로그인 실패")
        }
    }

    // MARK: - Actions

    @objc
    private func guestButtonDidTap() {
        onGuestDidTap?()
    }

    @objc
    func kakaoLoginButtonDidTap() {
        viewModel.action(.kakaoLoginButtonDidTap)
    }
    
    @objc
    private func appleLoginButtonDidTap() {
        viewModel.action(.appleLoginButtonDidTap)
    }
}
