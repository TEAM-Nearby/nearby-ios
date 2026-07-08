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
        
        bindViewModel()
    }
    
    // MARK: - Custom Method
    
    override func setAddTarget() {
        loginView.kakaoLoginButton.addTarget(
            self, action: #selector(kakaoLoginButtonDidTap), for: .touchUpInside
        )
    }
}

// MARK: - Private Method

private extension LoginViewController {
    
    func bindViewModel() {
        viewModel.output.loginDidSucceed = { [weak self] onboardingStatus in
            switch onboardingStatus {
            case .started:
                print("휴대폰인증 화면으로 이동해야됨")
                // TODO: - 코디네이터 연결후에 PhoneVerificationViewController로 이동
                
            case .phoneVerified:
                print("동행 프로필 설정 화면으로 이동해야됨")
                // TODO: - 코디네이터 연결후에 CompanionProfileViewController로 이동
                
            case .completed:
                print("메인탭 화면으로 이동해야됨")
                // TODO: - 코디네이터 연결후에 메인탭으로 이동
            }
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
