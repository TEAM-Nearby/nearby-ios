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

    // MARK: - Actions

    func action(_ trigger: Input) {
        switch trigger {
        case .sendVerificationButtonDidTap:
            break

        case .nextButtonDidTap:
            break
        }
    }
}
