//
//  AuthService.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

protocol AuthService {
    func loginWithKakao(request: KakaoLoginRequestDTO) async throws -> KakaoLoginResponseDTO
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
}
