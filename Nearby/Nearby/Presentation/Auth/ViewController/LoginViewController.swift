//
//  LoginViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/6/26.
//

import UIKit

final class LoginViewController: BaseViewController<LoginViewModel> {

    // MARK: - UI Components

    private let loginView = LoginView()

    // MARK: - Life Cycles

    override func loadView() {
        self.view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Custom Methods

    func setAddTarget() {
        loginView.kakaoLoginButton.addTarget(
            self,
            action: #selector(kakaoLoginButtonDidTap),
            for: .touchUpInside
        )
    }

    // MARK: - Action

    @objc
    private func kakaoLoginButtonDidTap() {
        viewModel.action(.kakaoLoginButtonDidTap)
        print("카카오 로그인 버튼 탭")
    }
}
