//
//  AlarmViewModel.swift
//  Nearby
//
//  Created by 신서연 on 7/10/26.
//

import Foundation

enum AlarmRequestType {
    case sent
    case received
}

final class AlarmViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case backButtonDidTap
        case sentRequestButtonDidTap
        case receivedRequestButtonDidTap
    }

    // MARK: - Output

    struct Output {
        var selectedRequestType: ((AlarmRequestType) -> Void)?
        var backButtonDidTap: (() -> Void)?
    }

    // MARK: - Properties

    var output = Output()

    private var selectedRequestType: AlarmRequestType = .sent

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            output.selectedRequestType?(selectedRequestType)

        case .backButtonDidTap:
            output.backButtonDidTap?()

        case .sentRequestButtonDidTap:
            updateSelectedRequestType(.sent)

        case .receivedRequestButtonDidTap:
            updateSelectedRequestType(.received)
        }
    }
}

// MARK: - Private Method

private extension AlarmViewModel {
    func updateSelectedRequestType(
        _ requestType: AlarmRequestType
    ) {
        guard selectedRequestType != requestType else {
            return
        }

        selectedRequestType = requestType
        output.selectedRequestType?(requestType)
    }
}
