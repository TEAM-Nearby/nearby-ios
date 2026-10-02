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
        case appleLoginButtonDidTap
    }

    // MARK: - Output
    
    struct Output {
        var loginDidSucceed: ((OnboardingStatus) -> Void)?
        var loginDidFail: ((Error) -> Void)?
    }
    
    // MARK: - Properties
    
    var output: Output
    
    private let authRepository: AuthRepository
    
    // MARK: - Initializer
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
        self.output = Output()
    }
    
    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .kakaoLoginButtonDidTap:
            loginWithKakaoAccount()
        case .appleLoginButtonDidTap:
            loginWithApple()
        }
    }

    // MARK: - Method

    func loginWithKakaoAccount() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                let onboardingStatus = try await authRepository.loginWithKakao()
                output.loginDidSucceed?(onboardingStatus)
            } catch {
                output.loginDidFail?(error)
            }
        }
    }
    
    func loginWithApple() {
        Task { @MainActor in
            do {
                let credential = try await authRepository.loginWithApple()

                print("애플 로그인 성공")
                print("identityToken : \(!credential.identityToken.isEmpty)")
                print("authorizationCode : \(!credential.authorizationCode.isEmpty)")
            } catch {
                print("애플 로그인 실패 : \(error)")
            }
        }
    }
}
