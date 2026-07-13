//
//  AuthService.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

protocol AuthService {
    func loginWithKakao(request: KakaoLoginRequestDTO) async throws -> KakaoLoginResponseDTO
    
    func sendVerificationCode(request: PhoneVerificationRequestDTO) async throws -> PhoneVerificationResponseDTO

    func confirmVerificationCode(phoneVerificationId: Int, request: PhoneVerificationConfirmRequestDTO) async throws -> PhoneVerificationConfirmResponseDTO
}

final class DefaultAuthService {

    // MARK: - Property

    private let networkProvider: NetworkProvider

    // MARK: - Initializer

    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
}

// MARK: - AuthService

extension DefaultAuthService: AuthService {
    func loginWithKakao(request: KakaoLoginRequestDTO) async throws -> KakaoLoginResponseDTO {
        try await networkProvider.request(
            AuthTarget.kakaoLogin(request),
            responseType: KakaoLoginResponseDTO.self
        )
    }
    
    func sendVerificationCode(request: PhoneVerificationRequestDTO) async throws -> PhoneVerificationResponseDTO {
        try await networkProvider.request(
            AuthTarget.sendVerificationCode(request),
            responseType: PhoneVerificationResponseDTO.self
        )
    }

    func confirmVerificationCode(phoneVerificationId: Int, request: PhoneVerificationConfirmRequestDTO) async throws -> PhoneVerificationConfirmResponseDTO {
        try await networkProvider.request(
            AuthTarget.confirmVerificationCode(phoneVerificationId: phoneVerificationId, request: request),
            responseType: PhoneVerificationConfirmResponseDTO.self
        )
    }
}
