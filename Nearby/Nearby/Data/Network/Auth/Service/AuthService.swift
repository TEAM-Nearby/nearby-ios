//
//  AuthService.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

protocol AuthService {
    func loginWithKakao(request: KakaoLoginRequestDTO) async throws -> KakaoLoginResponseDTO
}

final class DefaultAuthService: AuthService {
    private let networkProvider: NetworkProvider

    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }

    func loginWithKakao(request: KakaoLoginRequestDTO) async throws -> KakaoLoginResponseDTO {
        try await networkProvider.request(
            AuthTarget.kakaoLogin(request),
            responseType: KakaoLoginResponseDTO.self
        )
    }
}
