//
//  SettingViewModel.swift
//  Nearby
//
//  Created by 신서연 on 7/10/26.
//

import Foundation

final class SettingViewModel: BaseViewModelType, RequestRunning {
    let requestRunner = RequestRunner()

    // MARK: - Input

    enum Input {
        case backButtonDidTap
        case logoutButtonDidTap
        case agreementButtonDidTap
    }

    // MARK: - Output

    struct Output {
        var backButtonDidTap: (() -> Void)?
        var logoutButtonDidTap: (() -> Void)?
        var agreementButtonDidTap: (() -> Void)?
        var logoutErrorMessage: ((String) -> Void)?
        var isLogoutLoading: ((Bool) -> Void)?
    }

    // MARK: - Property

    var output = Output()

    private let authRepository: AuthRepository
    private var logoutTask: Task<Void, Never>?

    // MARK: - Initializer

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    deinit {
        logoutTask?.cancel()
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .backButtonDidTap:
            output.backButtonDidTap?()

        case .logoutButtonDidTap:
            logout()
        
        case .agreementButtonDidTap:
            output.agreementButtonDidTap?()
        }
    }
}

// MARK: - Private Methods

private extension SettingViewModel {
    func logout() {
        guard logoutTask == nil else { return }

        logoutTask = requestRunner.run(
            onStart: { [self] in
                output.isLogoutLoading?(true)
            },
            operation: { [self] in
                try await authRepository.logout()
            },
            onSuccess: { [self] _ in
                output.logoutButtonDidTap?()
            },
            onFailure: { [self] error in
                let message = (error as? LocalizedError)?.errorDescription
                    ?? "로그아웃에 실패했습니다. 다시 시도해 주세요."
                output.logoutErrorMessage?(message)
            },
            onFinish: { [self] in
                logoutTask = nil
                output.isLogoutLoading?(false)
            }
        )
    }
}
