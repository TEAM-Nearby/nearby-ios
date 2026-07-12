//
//  AlarmViewModel.swift
//  Nearby
//
//  Created by 신서연 on 7/10/26.
//

import Foundation

final class AlarmViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case backButtonDidTap
        case sentRequestButtonDidTap
        case receivedRequestButtonDidTap
        case requestActionButtonDidTap(id: UUID)
    }

    // MARK: - Output

    struct Output {
        var selectedTab: ((AlarmTab) -> Void)?
        var requestItems: (([AlarmRequestItem]) -> Void)?
        var backButtonDidTap: (() -> Void)?
        var requestActionDidTap: ((AlarmRequestItem) -> Void)?
    }

    // MARK: - Properties

    var output = Output()

    private var selectedTab: AlarmTab

    private var sentRequestItems:
        [AlarmRequestItem] = []

    private var receivedRequestItems:
        [AlarmRequestItem] = []
    
    // MARK: - Initializer

    init(initialTab: AlarmTab = .sent) {
        selectedTab = initialTab
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            emitCurrentState()

        case .backButtonDidTap:
            output.backButtonDidTap?()

        case .sentRequestButtonDidTap:
            updateSelectedTab(.sent)

        case .receivedRequestButtonDidTap:
            updateSelectedTab(.received)

        case .requestActionButtonDidTap(let id):
            handleRequestActionButtonDidTap(id: id)
        }
    }
}

// MARK: - Private Methods

private extension AlarmViewModel {
    func updateSelectedTab(_ tab: AlarmTab) {
        guard selectedTab != tab else {
            return
        }

        selectedTab = tab
        emitCurrentState()
    }

    func emitCurrentState() {
        output.selectedTab?(selectedTab)
        output.requestItems?(currentRequestItems)
    }

    func handleRequestActionButtonDidTap(
        id: UUID
    ) {
        guard let requestItem =
                currentRequestItems.first(
                    where: { $0.id == id }
                ) else {
            return
        }

        output.requestActionDidTap?(requestItem)
    }

    var currentRequestItems:
        [AlarmRequestItem] {

        switch selectedTab {
        case .sent:
            return sentRequestItems

        case .received:
            return receivedRequestItems
        }
    }
}
