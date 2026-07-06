//
//  LoginViewModel.swift
//  Nearby
//
//  Created by 신서연 on 7/6/26.
//

import Foundation

final class LoginViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case kakaoLoginButtonDidTap
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
        case .kakaoLoginButtonDidTap:
            break
        }
    }
}
