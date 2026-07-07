//
//  LoginViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/6/26.
//

import UIKit

final class LoginViewController: BaseViewController<LoginViewModel> {

    // MARK: - UI Component

    private let loginView = LoginView()

    // MARK: - Life Cycle

    override func loadView() {
        self.view = loginView
    }

    // MARK: - Custom Method

    func setAddTarget() {
        loginView.kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonDidTap), for: .touchUpInside)
    }

    // MARK: - Action

    @objc
    private func kakaoLoginButtonDidTap() {
        viewModel.action(.kakaoLoginButtonDidTap)
        // TODO: - 카카오 로그인 버튼 탭
        // print("카카오 로그인 버튼 탭")
    }
}
