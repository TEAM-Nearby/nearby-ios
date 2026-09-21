//
//  MatchingScheduleDetailViewModel.swift
//  Nearby
//
//  Created by 장지인 on 7/11/26.
//

import Combine
import Foundation

final class MatchingScheduleDetailViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case backButtonDidTap
        case alarmButtonDidTap
        case editButtonDidTap
        case shareButtonDidTap
    }

    // MARK: - Output

    struct Output {
        let displayData = PassthroughSubject<MatchingScheduleDetailDisplayData, Never>()
        let showBack = PassthroughSubject<Void, Never>()
        let showAlarm = PassthroughSubject<Void, Never>()
        let showEdit = PassthroughSubject<MatchingScheduleDetailDisplayData, Never>()
        let showShare = PassthroughSubject<Void, Never>()
    }

    // MARK: - Properties

    let output = Output()

    private let matchId: Int
    private let repository: MatchedCompanionListRepository
    private var currentDisplayData: MatchingScheduleDetailDisplayData?
    private var fetchTask: Task<Void, Never>?

    // MARK: - Initializer

    init(matchId: Int, repository: MatchedCompanionListRepository) {
        self.matchId = matchId
        self.repository = repository
    }

    deinit {
        fetchTask?.cancel()
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchMatchMySchedule()

        case .backButtonDidTap:
            output.showBack.send(())

        case .alarmButtonDidTap:
            output.showAlarm.send(())

        case .editButtonDidTap:
            guard let displayData = currentDisplayData else { return }
            output.showEdit.send(displayData)

        case .shareButtonDidTap:
            output.showShare.send(())
        }
    }

    // MARK: - Methods

    private func fetchMatchMySchedule() {
        fetchTask?.cancel()
        fetchTask = Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                async let scheduleResponseTask = repository.fetchMatchMySchedule(matchId: matchId)
                async let previewResponseTask = repository.fetchMatchPreview(matchId: matchId)

                let scheduleResponse = try await scheduleResponseTask
                let previewResponse = try? await previewResponseTask
                guard !Task.isCancelled else { return }
                let currentUserRole = scheduleResponse.currentUserRole.nearbyUserType
                let cardItem = previewResponse?.toCardItem(
                    type: currentUserRole,
                    matchStatus: scheduleResponse.matchStatus.rawValue,
                    fallbackPlaceName: scheduleResponse.schedule?.place.name ?? ""
                ) ?? scheduleResponse.toCardItem(type: currentUserRole)
                let displayData = scheduleResponse.toDisplayData(
                    type: currentUserRole,
                    cardItem: cardItem
                )
                currentDisplayData = displayData
                output.displayData.send(displayData)
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                AppLogger.error(error, message: "매칭 상세 조회에 실패했습니다.")
            }
        }
    }
}
