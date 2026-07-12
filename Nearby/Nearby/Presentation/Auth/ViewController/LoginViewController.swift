//
//  LoginViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/6/26.
//

import UIKit

final class LoginViewController: BaseViewController<LoginViewModel> {
    
    // MARK: - Property
    
    var onLoginDidSucceed: ((OnboardingStatus) -> Void)?
    
    // MARK: - UI Component
    
    private let loginView = LoginView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    // MARK: - Custom Method
    
    override func setAddTarget() {
        loginView.kakaoLoginButton.addTarget(
            self, action: #selector(kakaoLoginButtonDidTap), for: .touchUpInside
        )
    }
}

// MARK: - LoginViewController 익스텐션

private extension LoginViewController {
    
    func bindViewModel() {
        viewModel.output.loginDidSucceed = { [weak self] onboardingStatus in
            self?.onLoginDidSucceed?(onboardingStatus)
        }
        
        viewModel.output.loginDidFail = { error in
            print("카카오 로그인 실패:", error)
        }
    }
    
    @objc
    func kakaoLoginButtonDidTap() {
        viewModel.action(.kakaoLoginButtonDidTap)
    }
}
