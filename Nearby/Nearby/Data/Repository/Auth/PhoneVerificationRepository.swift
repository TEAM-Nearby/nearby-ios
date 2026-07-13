//
//  PhoneVerificationRepository.swift
//  Nearby
//
//  Created by 신서연 on 7/13/26.
//

protocol PhoneVerificationRepository {

    func sendVerificationCode(
        phoneNumber: String
    ) async throws -> PhoneVerificationResponseDTO

    func confirmVerificationCode(
        phoneVerificationId: Int,
        verificationCode: String
    ) async throws -> PhoneVerificationConfirmResponseDTO
}

final class DefaultPhoneVerificationRepository {

    // MARK: - Property

    private let phoneVerificationService: PhoneVerificationService

    // MARK: - Initializer

    init(phoneVerificationService: PhoneVerificationService) {
        self.phoneVerificationService = phoneVerificationService
    }
}

// MARK: - PhoneVerificationRepository

extension DefaultPhoneVerificationRepository: PhoneVerificationRepository {

    func sendVerificationCode(
        phoneNumber: String
    ) async throws -> PhoneVerificationResponseDTO {
        let request = PhoneVerificationRequestDTO(phoneNumber: phoneNumber)

        return try await phoneVerificationService.sendVerificationCode(
            request: request
        )
    }

    func confirmVerificationCode(
        phoneVerificationId: Int,
        verificationCode: String
    ) async throws -> PhoneVerificationConfirmResponseDTO {
        let request = PhoneVerificationConfirmRequestDTO(verificationCode: verificationCode)

        return try await phoneVerificationService.confirmVerificationCode(phoneVerificationId: phoneVerificationId, request: request)
    }
}
