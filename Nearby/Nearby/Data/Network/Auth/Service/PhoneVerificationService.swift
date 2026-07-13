//
//  PhoneVerificationService.swift
//  Nearby
//
//  Created by 신서연 on 7/13/26.
//

protocol PhoneVerificationService {

    func sendVerificationCode(request: PhoneVerificationRequestDTO) async throws -> PhoneVerificationResponseDTO

    func confirmVerificationCode(phoneVerificationId: Int, request: PhoneVerificationConfirmRequestDTO) async throws -> PhoneVerificationConfirmResponseDTO
}

final class DefaultPhoneVerificationService {

    // MARK: - Property

    private let networkProvider: NetworkProvider

    // MARK: - Initializer

    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
}

// MARK: - PhoneVerificationService

extension DefaultPhoneVerificationService: PhoneVerificationService {

    func sendVerificationCode(request: PhoneVerificationRequestDTO) async throws -> PhoneVerificationResponseDTO {
        try await networkProvider.request(
            PhoneVerificationTarget.sendVerificationCode(request),
            responseType: PhoneVerificationResponseDTO.self
        )
    }

    func confirmVerificationCode(phoneVerificationId: Int, request: PhoneVerificationConfirmRequestDTO) async throws -> PhoneVerificationConfirmResponseDTO {
        try await networkProvider.request(
            PhoneVerificationTarget.confirmVerificationCode(phoneVerificationId: phoneVerificationId, request: request),
            responseType: PhoneVerificationConfirmResponseDTO.self
        )
    }
}
