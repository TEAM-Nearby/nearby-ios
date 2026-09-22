//
//  MatchingManageDetailViewModel.swift
//  Nearby
//
//  Created by 장지인 on 7/11/26.
//

import Combine
import Foundation

final class MatchingManageDetailViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case backButtonDidTap
        case alarmButtonDidTap
        case dateDidChange(Date)
        case confirmButtonDidTap
    }

    // MARK: - Output

    struct Output {
        let displayData = PassthroughSubject<DisplayData, Never>()
        let dateButtonTitle = PassthroughSubject<String, Never>()
        let showBack = PassthroughSubject<Void, Never>()
        let showAlarm = PassthroughSubject<Void, Never>()
    }

    struct DisplayData {
        let cardItem: MatchingMatchedCardItem
        let placeName: String
        let placeAddress: String
        let googlePlaceId: String?
        let latitude: Double
        let longitude: Double
        let selectedDate: Date
        let dateButtonTitle: String
    }

    // MARK: - Properties

    let output = Output()

    private var displayData: MatchingScheduleDetailDisplayData
    private let repository: MatchedCompanionListRepository
    private let matchId: Int
    private var selectedDate = Date()
    private var fetchTask: Task<Void, Never>?
    private var confirmTask: Task<Void, Never>?

    // MARK: - Initializer

    init(matchId: Int, repository: MatchedCompanionListRepository) {
        self.matchId = matchId
        self.displayData = MatchingScheduleDetailDisplayData(
            cardItem: MatchingMatchedCardItem(
                matchId: matchId,
                content: MatchingMatchedCardContentModel(
                    name: "", participantCount: 1, gender: "",
                    uploadedTime: "", place: "", meetingTime: "", description: ""
                )
            ),
            placeName: "", placeAddress: "", googlePlaceId: nil,
            latitude: 0, longitude: 0,
            scheduledAt: nil, scheduledAtText: "", openChatUrl: "",
            type: .host
        )
        self.repository = repository
    }

    deinit {
        fetchTask?.cancel()
        confirmTask?.cancel()
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchDisplayData()

        case .backButtonDidTap:
            output.showBack.send(())

        case .alarmButtonDidTap:
            output.showAlarm.send(())

        case .dateDidChange(let date):
            selectedDate = date
            output.dateButtonTitle.send(selectedDate.displayDateString)

        case .confirmButtonDidTap:
            confirmSchedule()
        }
    }

    // MARK: - Methods

    private func makeDisplayData() -> DisplayData {
        return DisplayData(
            cardItem: displayData.cardItem,
            placeName: displayData.placeName,
            placeAddress: displayData.placeAddress,
            googlePlaceId: displayData.googlePlaceId,
            latitude: displayData.latitude,
            longitude: displayData.longitude,
            selectedDate: selectedDate, dateButtonTitle: selectedDate.displayDateString
        )
    }

    private func confirmSchedule() {
        let scheduledAt = makeScheduledAt()
        let matchID = displayData.cardItem.matchId
        let repository = repository

        confirmTask?.cancel()
        confirmTask = Task { @MainActor [weak self, repository] in
            do {
                try await repository.confirmSchedule(matchId: matchID, scheduledAt: scheduledAt)
                guard let self, !Task.isCancelled else { return }
                output.showBack.send(())
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                AppLogger.error(error, message: "동행 일정 확정에 실패했습니다.")
            }
        }
    }

    private func makeScheduledAt() -> String {
        let normalizedDate = Calendar.current.date(
            bySetting: .second,
            value: 0,
            of: selectedDate
        ) ?? selectedDate
        return normalizedDate.apiDateString
    }
    
    private func fetchDisplayData() {
        let matchID = matchId

        fetchTask?.cancel()
        let repository = repository
        fetchTask = Task { @MainActor [weak self, repository] in

            do {
                async let scheduleResponseTask = repository.fetchMatchMySchedule(matchId: matchID)
                async let previewResponseTask = repository.fetchMatchPreview(matchId: matchID)

                let scheduleResponse = try await scheduleResponseTask
                let previewResponse = try? await previewResponseTask
                guard let self, !Task.isCancelled else { return }
                displayData = MatchingScheduleDetailMapper.map(
                    scheduleDetail: scheduleResponse,
                    preview: previewResponse
                )
                selectedDate = displayData.scheduledAt?.toDate() ?? Date()
                output.displayData.send(makeDisplayData())
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                AppLogger.error(error, message: "매칭 상세 조회에 실패했습니다.")
            }
        }
    }
}

private extension Date {
    var displayDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd  HH:mm"
        return formatter.string(from: self)
    }
}
