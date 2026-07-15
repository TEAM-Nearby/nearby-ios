//
//  AuthRepository.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

import Foundation

protocol AuthRepository {
    func loginWithKakao() async throws -> OnboardingStatus
    func logout() async throws
    func sendVerificationCode(phoneNumber: String) async throws -> PhoneVerificationResponseDTO
    func confirmVerificationCode(phoneVerificationId: Int, verificationCode: String) async throws -> PhoneVerificationConfirmResponseDTO
    func completeCompanionProfile(nickname: String, gender: NearbyGender, intro: String?,
                                  travelStyleKeywords: [String], imageData: Data?, imageFileName: String?, imageContentType: String?) async throws -> CompanionProfileResponseDTO
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

        let storedTokenUserId = tokenStorage.currentUserId
        let storedTokenSubject = storedTokenUserId.map { String($0) } ?? "nil"
        AppLogger.data(
            "[AuthIdentity] loginResponse.userId=\(response.userId), "
                + "storedAccessToken.sub=\(storedTokenSubject)"
        )

        if storedTokenUserId != response.userId {
            let error = NSError(
                domain: "AuthIdentityMismatch",
                code: 1,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "로그인 응답 userId와 저장된 Access Token sub가 일치하지 않습니다."
                ]
            )
            AppLogger.error(error, message: "[AuthIdentity] 사용자 식별자 불일치")
        }

        return response.onboardingStatus
    }

    func logout() async throws {
        guard let refreshToken = tokenStorage.refreshToken, !refreshToken.isEmpty else {
            throw NetworkError.unauthorized(code: "MISSING_REFRESH_TOKEN", message: "로그인 정보가 없습니다.")
        }

        let response = try await authService.logout(
            request: LogoutRequestDTO(refreshToken: refreshToken)
        )

        guard response.loggedOut else {
            throw NetworkError.serverError(status: 200, code: "LOGOUT_FAILED", message: "로그아웃 처리에 실패했습니다.")
        }

        try tokenStorage.clear()

        do {
            try await oauthProvider.logout()
        } catch {
            AppLogger.error(error, message: "카카오 SDK 로그아웃 실패")
        }
    }
    
    func sendVerificationCode(phoneNumber: String) async throws -> PhoneVerificationResponseDTO {
        let request = PhoneVerificationRequestDTO(phoneNumber: phoneNumber)

        return try await authService.sendVerificationCode(request: request)
    }

    func confirmVerificationCode(phoneVerificationId: Int, verificationCode: String) async throws -> PhoneVerificationConfirmResponseDTO {
        let request = PhoneVerificationConfirmRequestDTO(verificationCode: verificationCode)

        return try await authService.confirmVerificationCode(phoneVerificationId: phoneVerificationId, request: request)
    }
    
    func completeCompanionProfile(nickname: String, gender: NearbyGender, intro: String?, travelStyleKeywords: [String],
                                  imageData: Data?, imageFileName: String?, imageContentType: String?) async throws -> CompanionProfileResponseDTO {
        let profileImageURL: String?

        if let imageData, let imageFileName, let imageContentType {
            let uploadResponse =
                try await authService.issueProfileImageUploadURL(
                    request: ProfileImageUploadURLRequestDTO(
                        fileName: imageFileName,
                        contentType: imageContentType,
                        fileSize: imageData.count
                    )
                )

            try await authService.uploadProfileImage(data: imageData, uploadURL: uploadResponse.uploadUrl, headers: uploadResponse.headers)

            profileImageURL = uploadResponse.imageUrl
        } else {
            profileImageURL = nil
        }

        let genderValue: String

        switch gender {
        case .male:
            genderValue = "MALE"

        case .female:
            genderValue = "FEMALE"
        }

        let request = CompanionProfileRequestDTO(nickname: nickname, gender: genderValue, intro: intro, profileImageUrl: profileImageURL, travelStyleKeywords: travelStyleKeywords)

        return try await authService.createCompanionProfile(
            request: request
        )
    }
}
