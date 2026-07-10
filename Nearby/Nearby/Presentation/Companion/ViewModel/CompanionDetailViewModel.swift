//
//  CompanionDetailViewModel.swift
//  Nearby
//
//  Created by soomin on 7/10/26.
//

import Combine

final class CompanionDetailViewModel: BaseViewModelType {

    // MARK: - Route

    enum Route {
        case close
        case applyCompanion
    }

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case backButtonDidTap
        case applyButtonDidTap
    }

    // MARK: - Output

    struct Output {
        let displayState = PassthroughSubject<CompanionDetailState, Never>()
    }

    // MARK: - Properties

    var route: ((Route) -> Void)?
    let output = Output()
    private let state: CompanionDetailState

    // MARK: - Initializer

    init(state: CompanionDetailState) {
        self.state = state
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            output.displayState.send(state)
        case .backButtonDidTap:
            route?(.close)
        case .applyButtonDidTap:
            guard state.isApplicationEnabled else { return }
            route?(.applyCompanion)
        }
    }
}
