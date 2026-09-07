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
        case viewWillAppear
        case alarmButtonDidTap
        case settingButtonDidTap
        case writtenPostRowDidTap
        case sentRequestRowDidTap
        case receivedRequestRowDidTap
    }

    // MARK: - Output

    struct Output {
        var myPageData: ((MyPageDisplayModel) -> Void)?
        var errorMessage: ((String) -> Void)?
        var alarmButtonDidTap: (() -> Void)?
        var settingButtonDidTap: (() -> Void)?
        var writtenPostRowDidTap: (() -> Void)?
        var sentRequestRowDidTap: (() -> Void)?
        var receivedRequestRowDidTap: (() -> Void)?
    }

    // MARK: - Properties

    var output = Output()

    private let repository: MyPageRepository

    private var fetchTask: Task<Void, Never>?

    // MARK: - Initializer

    init(repository: MyPageRepository) {
        self.repository = repository
    }

    deinit {
        fetchTask?.cancel()
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewWillAppear:
            fetchMyPage()

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

// MARK: - Private Methods

private extension MyPageViewModel {

    func fetchMyPage() {
        fetchTask?.cancel()

        fetchTask = Task { [weak self] in
            guard let self else { return }

            do {
                let response = try await repository.fetchMyPage()

                guard !Task.isCancelled else {
                    return
                }

                let displayModel = MyPageDisplayModel(
                    response: response
                )

                await MainActor.run {
                    self.output.myPageData?(displayModel)
                }
            } catch {
                guard !Task.isCancelled else {
                    return
                }

                let message: String

                if let localizedError = error as? LocalizedError,
                   let errorDescription = localizedError.errorDescription {
                    message = errorDescription
                } else {
                    message = "마이페이지 정보를 불러오지 못했습니다."
                }

                await MainActor.run {
                    self.output.errorMessage?(message)
                }
            }
        }
    }
}
