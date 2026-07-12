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
        case writtenPostRowDidTap
        case sentRequestRowDidTap
        case receivedRequestRowDidTap
    }

    // MARK: - Output

    struct Output {
        var alarmButtonDidTap: (() -> Void)?
        var settingButtonDidTap: (() -> Void)?
        var writtenPostRowDidTap: (() -> Void)?
        var sentRequestRowDidTap: (() -> Void)?
        var receivedRequestRowDidTap: (() -> Void)?
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

        case .writtenPostRowDidTap:
            output.writtenPostRowDidTap?()

        case .sentRequestRowDidTap:
            output.sentRequestRowDidTap?()

        case .receivedRequestRowDidTap:
            output.receivedRequestRowDidTap?()
        }
    }
}
