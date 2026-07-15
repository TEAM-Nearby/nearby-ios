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
        }
    }
}

// MARK: - Private Methods

private extension SettingViewModel {
    func logout() {
        guard logoutTask == nil else { return }

        output.isLogoutLoading?(true)
        logoutTask = Task { [weak self] in
            guard let self else { return }
            defer {
                logoutTask = nil
                output.isLogoutLoading?(false)
            }

            do {
                try await authRepository.logout()
                guard !Task.isCancelled else { return }
                output.logoutButtonDidTap?()
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }

                let message = (error as? LocalizedError)?.errorDescription
                    ?? "로그아웃에 실패했습니다. 다시 시도해 주세요."
                output.logoutErrorMessage?(message)
            }
        }
    }
}
