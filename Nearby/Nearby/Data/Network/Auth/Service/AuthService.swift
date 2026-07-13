//
//  AuthService.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

import Foundation

import Alamofire

protocol AuthService {
    func loginWithKakao(request: KakaoLoginRequestDTO) async throws -> KakaoLoginResponseDTO

    func sendVerificationCode(request: PhoneVerificationRequestDTO) async throws -> PhoneVerificationResponseDTO

    func confirmVerificationCode(phoneVerificationId: Int, request: PhoneVerificationConfirmRequestDTO) async throws -> PhoneVerificationConfirmResponseDTO

    func issueProfileImageUploadURL(request: ProfileImageUploadURLRequestDTO) async throws -> ProfileImageUploadURLResponseDTO

    func uploadProfileImage(data: Data, uploadURL: String, headers: [String: String]) async throws

    func createCompanionProfile(request: CompanionProfileRequestDTO) async throws -> CompanionProfileResponseDTO
}

final class DefaultAuthService {

    // MARK: - Properties

    private let networkProvider: NetworkProvider
    private let session: Session

    // MARK: - Initializer

    init(
        networkProvider: NetworkProvider,
        session: Session = .default
    ) {
        self.networkProvider = networkProvider
        self.session = session
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

    func issueProfileImageUploadURL(request: ProfileImageUploadURLRequestDTO) async throws -> ProfileImageUploadURLResponseDTO {
        try await networkProvider.request(
            AuthTarget.issueProfileImageUploadURL(request),
            responseType: ProfileImageUploadURLResponseDTO.self
        )
    }

    func uploadProfileImage(data: Data, uploadURL: String, headers: [String: String]) async throws {
        guard let url = URL(string: uploadURL) else {
            throw NetworkError.invalidURL
        }

        let httpHeaders = HTTPHeaders(
            headers.map {
                HTTPHeader(name: $0.key, value: $0.value)
            }
        )

        let response = await session.upload(data, to: url, method: .put, headers: httpHeaders)
        .serializingData(emptyResponseCodes: [200, 201, 204, 205])
        .response

        guard let statusCode = response.response?.statusCode else {
            if let error = response.error {
                AppLogger.error(error, message: "프로필 이미지 업로드 응답 없음")
            }
            
            throw NetworkError.networkFail
        }

        guard (200..<300).contains(statusCode) else {
            let responseBody: String
            
            if let data = response.data {
                responseBody = String(data: data, encoding: .utf8) ?? "응답 본문 없음"
            } else {
                responseBody = "응답 데이터 없음"
            }

            AppLogger.error(
                NetworkError.serverError(
                    status: statusCode,
                    code: "PROFILE_IMAGE_UPLOAD_FAILED",
                    message: responseBody
                ),
                message: "프로필 이미지 업로드 실패"
            )

            throw NetworkError.serverError(
                status: statusCode,
                code: "PROFILE_IMAGE_UPLOAD_FAILED",
                message: "프로필 이미지 업로드에 실패했습니다. 상태 코드: \(statusCode)"
            )
        }

        if let error = response.error {
            AppLogger.error(error, message: "프로필 이미지 업로드 오류")
            
            throw NetworkError.networkFail
        }
    }

    func createCompanionProfile(request: CompanionProfileRequestDTO) async throws -> CompanionProfileResponseDTO {
        try await networkProvider.request(
            AuthTarget.createCompanionProfile(request),
            responseType: CompanionProfileResponseDTO.self
        )
    }
}
