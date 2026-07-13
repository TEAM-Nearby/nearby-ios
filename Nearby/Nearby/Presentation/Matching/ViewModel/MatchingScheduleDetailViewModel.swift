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
        let showEdit = PassthroughSubject<MatchingMatchedCardItem, Never>()
        let showShare = PassthroughSubject<Void, Never>()
    }

    // MARK: - Properties

    let output = Output()

    private let matchId: Int
    private let repository: MatchedCompanionListRepository
    private var currentDisplayData: MatchingScheduleDetailDisplayData?

    // MARK: - Initializer

    init(matchId: Int, repository: MatchedCompanionListRepository) {
        self.matchId = matchId
        self.repository = repository
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchMatchDetail()

        case .backButtonDidTap:
            output.showBack.send(())

        case .alarmButtonDidTap:
            output.showAlarm.send(())

        case .editButtonDidTap:
            guard let item = currentDisplayData?.cardItem else { return }
            output.showEdit.send(item)

        case .shareButtonDidTap:
            output.showShare.send(())
        }
    }

    // MARK: - Method

    private func fetchMatchDetail() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                let response = try await repository.fetchMatchPreview(matchId: matchId)
                let displayData = response.toDisplayData(type: .participant)
                currentDisplayData = displayData
                output.displayData.send(displayData)
            } catch {
                AppLogger.error(error, message: "매칭 상세 조회에 실패했습니다.")
            }
        }
    }
}
