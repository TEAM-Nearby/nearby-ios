//
//  LoginViewModel.swift
//  Nearby
//
//  Created by 신서연 on 7/6/26.
//

import Foundation

final class LoginViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case kakaoLoginButtonDidTap
    }
    
    // MARK: - Output
    
    struct Output {
        var loginDidSucceed: ((OnboardingStatus) -> Void)?
        var loginDidFail: ((Error) -> Void)?
    }
    
    // MARK: - Property
    
    var output: Output
    
    private let kakaoAuthService = KakaoAuthService()
    
    // MARK: - Initializer
    
    init() {
        self.output = Output()
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .kakaoLoginButtonDidTap:
            loginWithKakaoAccount()
        }
    }
}

// MARK: - Private Method

private extension LoginViewModel {
    
    func loginWithKakaoAccount() {
        kakaoAuthService.loginWithKakaoAccount { [weak self] result in
            switch result {
            case .success(let loginData):
                print("Nearby Access Token:", loginData.accessToken)
                print("Nearby Refresh Token:", loginData.refreshToken)
                print("Nearby User ID:", loginData.userId)
                print("Onboarding Status:", loginData.onboardingStatus.rawValue)
                
                self?.output.loginDidSucceed?(loginData.onboardingStatus)
                
            case .failure(let error):
                self?.output.loginDidFail?(error)
            }
        }
    }
}
