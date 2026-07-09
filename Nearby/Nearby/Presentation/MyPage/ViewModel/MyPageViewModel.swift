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

    struct Output {}

    // MARK: - Property

    let output = Output()

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .alarmButtonDidTap:
            break

        case .settingButtonDidTap:
            break
        }
    }
}
