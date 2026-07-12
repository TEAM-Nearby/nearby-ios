//
//  AuthRepository.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

protocol AuthRepository {
    func loginWithKakao() async throws -> OnboardingStatus
}

final class DefaultAuthRepository: AuthRepository {
    private let oauthProvider: KakaoOAuthProvider
    private let authService: AuthService
    private let tokenStorage: TokenStorage

    init(oauthProvider: KakaoOAuthProvider, authService: AuthService, tokenStorage: TokenStorage) {
        self.oauthProvider = oauthProvider
        self.authService = authService
        self.tokenStorage = tokenStorage
    }

    func loginWithKakao() async throws -> OnboardingStatus {
        let credential = try await oauthProvider.requestCredential()
        let response = try await authService.loginWithKakao(
            request: KakaoLoginRequestDTO(idToken: credential.idToken, nonce: credential.nonce)
        )
        try tokenStorage.save(accessToken: response.accessToken, refreshToken: response.refreshToken)
        return response.onboardingStatus
    }
}
