//
//  PhoneVerificationViewModel.swift
//  Nearby
//
//  Created by 신서연 on 7/6/26.
//
/*
import Foundation

final class PhoneVerificationViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case sendVerificationButtonDidTap
        case nextButtonDidTap
    }

    // MARK: - Output

    struct Output { }

    // MARK: - Properties

    let output: Output

    // MARK: - Initializer

    init() {
        self.output = Output()
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .sendVerificationButtonDidTap:
            break

        case .nextButtonDidTap:
            break
        }
    }
}
*/

import Foundation

final class PhoneVerificationViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case bottomButtonDidTap
        case nextButtonDidTap
    }

    // MARK: - Output

    struct Output {
        var isVerificationMode: ((Bool) -> Void)?
    }

    // MARK: - Property

    var output: Output

    private var isVerificationMode = false

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
