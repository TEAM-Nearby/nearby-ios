//
//  MyPageViewModel.swift
//  Nearby
//
//  Created by 신서연 on 7/9/26.
//

import Foundation

final class MyPageViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case alarmButtonDidTap
        case settingButtonDidTap
    }

    // MARK: - Output

    struct Output {
        var alarmButtonDidTap: (() -> Void)?
        var settingButtonDidTap: (() -> Void)?
    }

    // MARK: - Property

    var output = Output()

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .alarmButtonDidTap:
            output.alarmButtonDidTap?()

        case .settingButtonDidTap:
            output.settingButtonDidTap?()
        }
    }
}
