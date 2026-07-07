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
        case .bottomButtonDidTap:
            if isVerificationMode {
                action(.nextButtonDidTap)
            } else {
                isVerificationMode = true
                output.isVerificationMode?(true)

                // TODO: - 인증문자 발송 로직
            }

        case .nextButtonDidTap:
            // TODO: - 다음 버튼 탭 로직
            break
        }
    }
}
