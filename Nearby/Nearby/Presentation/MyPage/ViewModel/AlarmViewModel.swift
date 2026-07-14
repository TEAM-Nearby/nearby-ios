//
//  AlarmViewModel.swift
//  Nearby
//
//  Created by 신서연 on 7/10/26.
//

import Combine
import Foundation

final class AlarmViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case viewWillAppear
        case backButtonDidTap
        case sentRequestButtonDidTap
        case receivedRequestButtonDidTap
        case actionButtonDidTap(AlarmRequestItem)
    }

    // MARK: - Output

    struct Output {
        let selectedTab: CurrentValueSubject<AlarmTab, Never>
        let items = CurrentValueSubject<[AlarmRequestItem], Never>([])
        let isLoading = CurrentValueSubject<Bool, Never>(false)
        let errorMessage = PassthroughSubject<String, Never>()
        let backButtonDidTap = PassthroughSubject<Void, Never>()
        let showCompanionRequestAccept = PassthroughSubject<Int, Never>()
        let showCompanionRequestDecline = PassthroughSubject<Void, Never>()
        let showHostRequestReceive = PassthroughSubject<Int, Never>()
        let showSchedule = PassthroughSubject<Int, Never>()
    }

    // MARK: - Properties

    let output: Output

    private let repository: CompanionRequestRepository

    private var fetchTask: Task<Void, Never>?
    private var hasLoadedOnce = false

    // MARK: - Initializer

    init(initialTab: AlarmTab = .sent, repository: CompanionRequestRepository)
    {
        output = Output(selectedTab: CurrentValueSubject<AlarmTab, Never>(initialTab))
        self.repository = repository
    }

    deinit {
        fetchTask?.cancel()
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            guard !hasLoadedOnce else { return }

            hasLoadedOnce = true
            fetchRequests()

        case .viewWillAppear:
            guard hasLoadedOnce else { return }

            fetchRequests()

        case .backButtonDidTap:
            output.backButtonDidTap.send(())

        case .sentRequestButtonDidTap:
            updateSelectedTab(.sent)

        case .receivedRequestButtonDidTap:
            updateSelectedTab(.received)

        case .actionButtonDidTap(let item):
            handleAction(for: item)
        }
    }
}

// MARK: - Methods

private extension AlarmViewModel {

    func updateSelectedTab(_ tab: AlarmTab) {
        guard output.selectedTab.value != tab else {
            return
        }

        output.selectedTab.send(tab)
        fetchRequests()
    }

    func fetchRequests() {
        fetchTask?.cancel()

        let selectedTab = output.selectedTab.value
        let direction = selectedTab.direction

        output.isLoading.send(true)

        fetchTask = Task { [weak self] in
            guard let self else { return }

            defer {
                if !Task.isCancelled {
                    output.isLoading.send(false)
                }
            }

            do {
                let response = try await repository.fetchRequests(
                    direction: direction
                )

                guard !Task.isCancelled else { return }

                let items = response.requests.map {
                    AlarmRequestItem(dto: $0, tab: selectedTab)
                }

                output.items.send(items)
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }

                AppLogger.error(error)
                output.items.send([])
                output.errorMessage.send(error.localizedDescription)
            }
        }
    }

    func handleAction(for item: AlarmRequestItem) {
        switch item.actionType {
        case .confirmSchedule:
            handleConfirmSchedule(item)

        case .viewRejection, .viewResult:
            output.showCompanionRequestDecline.send(())

        case .acceptRequest:
            output.showHostRequestReceive.send(item.applicationId)

        case .none:
            break
        }
    }

    func handleConfirmSchedule(_ item: AlarmRequestItem) {
        switch item.tab {
        case .sent:
            output.showCompanionRequestAccept.send(item.applicationId)

        case .received:
            guard let matchId = item.matchId else {
                output.errorMessage.send("일정 정보를 확인할 수 없어요.")
                return
            }

            output.showSchedule.send(matchId)
        }
    }
}

// MARK: - AlarmTab

private extension AlarmTab {

    var direction: CompanionRequestDirection {
        switch self {
        case .sent:
            return .sent

        case .received:
            return .received
        }
    }
}
