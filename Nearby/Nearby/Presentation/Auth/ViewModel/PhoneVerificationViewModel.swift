//
//  PhoneVerificationViewModel.swift
//  Nearby
//
//  Created by 신서연 on 7/6/26.
//

import Foundation

final class PhoneVerificationViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case phoneNumberDidChange(String)
        case verificationCodeDidChange(String)
        case bottomButtonDidTap
        case backButtonDidTap
    }

    // MARK: - Output

    struct Output {
        var isVerificationMode: ((Bool) -> Void)?
        var verificationDidComplete: (() -> Void)?
        var shouldPopViewController: (() -> Void)?
        var phoneVerificationDidFail: ((String) -> Void)?
        var verificationCodeDidFail: ((String) -> Void)?
        var isLoading: ((Bool) -> Void)?
    }

    // MARK: - Properties

    var output: Output

    private let phoneVerificationRepository: PhoneVerificationRepository

    private var isVerificationMode = false
    private var phoneNumber = ""
    private var verificationCode = ""
    private var phoneVerificationID: Int?
    private var expiresIn = 0

    // MARK: - Initializer

    init(phoneVerificationRepository: PhoneVerificationRepository) {
        self.phoneVerificationRepository = phoneVerificationRepository
        self.output = Output()
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .phoneNumberDidChange(let phoneNumber):
            self.phoneNumber = phoneNumber

        case .verificationCodeDidChange(let verificationCode):
            self.verificationCode = verificationCode

        case .bottomButtonDidTap:
            if isVerificationMode {
                verifyVerificationCode()
            } else {
                sendVerificationCode()
            }

        case .backButtonDidTap:
            handleBackButtonDidTap()
        }
    }
}

// MARK: - Methods

private extension PhoneVerificationViewModel {
    func sendVerificationCode() {
        guard isValidPhoneNumber else {
            output.phoneVerificationDidFail?("올바른 전화번호 형식이 아니에요")
            return
        }

        Task { @MainActor [weak self] in
            guard let self else { return }

            output.isLoading?(true)

            defer {
                output.isLoading?(false)
            }

            do {
                let response = try await phoneVerificationRepository.sendVerificationCode(phoneNumber: phoneNumber)

                phoneVerificationID = response.phoneVerificationId
                expiresIn = response.expiresIn

                isVerificationMode = true
                output.isVerificationMode?(true)

            } catch {
                handleVerificationError(error)
            }
        }
    }

    func handleBackButtonDidTap() {
        if isVerificationMode {
            isVerificationMode = false
            verificationCode = ""
            phoneVerificationID = nil
            expiresIn = 0
            output.isVerificationMode?(false)
        } else {
            output.shouldPopViewController?()
        }
    }

    func handleVerificationError(_ error: Error) {
        AppLogger.error(error, message: "휴대폰 인증 문자 발송 실패")

        guard let networkError = error as? NetworkError else {
            output.phoneVerificationDidFail?("인증 문자 발송에 실패했습니다.")
            return
        }

        switch networkError {
        case .badRequest(let code, let message):
            if code == "VALIDATION_ERROR" {
                output.phoneVerificationDidFail?("올바른 전화번호 형식이 아니에요")
            } else {
                output.phoneVerificationDidFail?(message)
            }

        case .internalServerError(let code, let message):
            if code == "PHONE_VERIFICATION_SEND_LIMIT_EXCEEDED" {
                output.phoneVerificationDidFail?("인증 문자 발송 횟수를 초과했습니다.")
            } else {
                output.phoneVerificationDidFail?(message)
            }

        case .unauthorized(_, let message):
            output.phoneVerificationDidFail?(message)

        default:
            output.phoneVerificationDidFail?(networkError.localizedDescription)
        }
    }

    var isValidPhoneNumber: Bool {
        phoneNumber.count == 11
            && phoneNumber.hasPrefix("010")
            && phoneNumber.allSatisfy(\.isNumber)
    }
    
    func verifyVerificationCode() {
        guard !verificationCode.isEmpty else {
            output.verificationCodeDidFail?("인증번호를 입력해주세요")
            return
        }

        // TODO: - 인증번호 검증 API 연동 후 제거
        guard verificationCode == "123456" else {
            output.verificationCodeDidFail?("인증번호가 일치하지 않아요")
            return
        }

        output.verificationDidComplete?()
    }
}
