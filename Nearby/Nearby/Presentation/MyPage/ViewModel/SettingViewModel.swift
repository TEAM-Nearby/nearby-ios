//
//  SettingViewModel.swift
//  Nearby
//
//  Created by 신서연 on 7/10/26.
//

import Foundation

final class SettingViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case backButtonDidTap
        case logoutButtonDidTap
    }

    // MARK: - Output

    struct Output {
        var backButtonDidTap: (() -> Void)?
        var logoutButtonDidTap: (() -> Void)?
    }

    // MARK: - Property

    var output = Output()

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .backButtonDidTap:
            output.backButtonDidTap?()

        case .logoutButtonDidTap:
            output.logoutButtonDidTap?()
        }
    }
}
