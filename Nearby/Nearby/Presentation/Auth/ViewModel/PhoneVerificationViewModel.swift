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
    }

    // MARK: - Output

    struct Output {
        var isVerificationMode: ((Bool) -> Void)?
        var verificationDidComplete: (() -> Void)?
    }

    // MARK: - Property

    var output: Output

    private var isVerificationMode = false
    private var phoneNumber = ""
    private var verificationCode = ""

    // MARK: - Initializer

    init() {
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
                guard !verificationCode.isEmpty else { return }

                // TODO: - 인증번호 검증 API 성공후에 호출
                output.verificationDidComplete?()
            } else {
                guard !phoneNumber.isEmpty else { return }

                // TODO: - 인증문자 발송 API 성공후에 실행
                isVerificationMode = true
                output.isVerificationMode?(true)
            }
        }
    }
}
