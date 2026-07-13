//
//  AuthRepository.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

protocol AuthRepository {
    func loginWithKakao() async throws -> OnboardingStatus
    func sendVerificationCode(phoneNumber: String) async throws -> PhoneVerificationResponseDTO
    func confirmVerificationCode(phoneVerificationId: Int, verificationCode: String) async throws -> PhoneVerificationConfirmResponseDTO
}

final class DefaultAuthRepository {

    // MARK: - Properties

    private let oauthProvider: KakaoOAuthProvider
    private let authService: AuthService
    private let tokenStorage: TokenStorage

    // MARK: - Initializer

    init(oauthProvider: KakaoOAuthProvider, authService: AuthService, tokenStorage: TokenStorage) {
        self.oauthProvider = oauthProvider
        self.authService = authService
        self.tokenStorage = tokenStorage
    }
}

// MARK: - AuthRepository

extension DefaultAuthRepository: AuthRepository {
    func loginWithKakao() async throws -> OnboardingStatus {
        let credential = try await oauthProvider.requestCredential()
        let response = try await authService.loginWithKakao(
            request: KakaoLoginRequestDTO(idToken: credential.idToken, nonce: credential.nonce)
        )
        try tokenStorage.save(accessToken: response.accessToken, refreshToken: response.refreshToken)
        return response.onboardingStatus
    }
    
    func sendVerificationCode(phoneNumber: String) async throws -> PhoneVerificationResponseDTO {
        let request = PhoneVerificationRequestDTO(phoneNumber: phoneNumber)

        return try await authService.sendVerificationCode(request: request)
    }

    func confirmVerificationCode(phoneVerificationId: Int, verificationCode: String) async throws -> PhoneVerificationConfirmResponseDTO {
        let request = PhoneVerificationConfirmRequestDTO(verificationCode: verificationCode)

        return try await authService.confirmVerificationCode(phoneVerificationId: phoneVerificationId, request: request)
    }
}
