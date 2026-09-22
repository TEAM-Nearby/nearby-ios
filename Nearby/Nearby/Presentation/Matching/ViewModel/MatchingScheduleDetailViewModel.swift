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
        let showEdit = PassthroughSubject<Int, Never>()
        let showShare = PassthroughSubject<MatchingScheduleDetailDisplayData, Never>()
        let errorMessage = PassthroughSubject<String, Never>()
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
            output.showEdit.send(matchId)

        case .shareButtonDidTap:
            guard let displayData = currentDisplayData else { return }
            output.showShare.send(displayData)
        }
    }

    // MARK: - Methods

    private func fetchMatchMySchedule() {
        fetchTask?.cancel()
        let matchID = matchId
        let repository = repository
        fetchTask = Task { @MainActor [weak self, repository] in

            do {
                async let scheduleResponseTask = repository.fetchMatchMySchedule(matchId: matchID)
                async let previewResponseTask = repository.fetchMatchPreview(matchId: matchID)

                let scheduleResponse = try await scheduleResponseTask
                let previewResponse = try? await previewResponseTask
                guard let self, !Task.isCancelled else { return }
                let displayData = MatchingScheduleDetailMapper.map(
                    scheduleDetail: scheduleResponse,
                    preview: previewResponse
                )
                currentDisplayData = displayData
                output.displayData.send(displayData)
            } catch is CancellationError {
                return
            } catch {
                guard let self, !Task.isCancelled else { return }
                AppLogger.error(error, message: "매칭 상세 조회에 실패했습니다.")
                output.errorMessage.send("매칭 상세 정보를 불러오지 못했어요.")
            }
        }
    }
}
