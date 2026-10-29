//
//  MatchingManageDetailViewModel.swift
//  Nearby
//
//  Created by 장지인 on 7/11/26.
//

import Combine
import Foundation

final class MatchingManageDetailViewModel: BaseViewModelType, RequestRunning {
    let requestRunner = RequestRunner()

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
        let timeZone: TimeZone
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
            scheduledAt: nil, timeZoneID: nil, scheduledAtText: "", openChatUrl: "",
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
            output.dateButtonTitle.send(dateButtonTitle)

        case .confirmButtonDidTap:
            confirmSchedule()
        }
    }

    // MARK: - Methods

    private var scheduleTimeZone: TimeZone {
        displayData.timeZoneID.flatMap(TimeZone.init(identifier:)) ?? .nearbyFallbackTimeZone
    }

    private var dateButtonTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = scheduleTimeZone
        formatter.dateFormat = "yyyy-MM-dd  HH:mm"
        return formatter.string(from: selectedDate)
    }

    private func makeDisplayData() -> DisplayData {
        return DisplayData(
            cardItem: displayData.cardItem,
            placeName: displayData.placeName,
            placeAddress: displayData.placeAddress,
            googlePlaceId: displayData.googlePlaceId,
            latitude: displayData.latitude,
            longitude: displayData.longitude,
            selectedDate: selectedDate, dateButtonTitle: dateButtonTitle,
            timeZone: scheduleTimeZone
        )
    }

    private func confirmSchedule() {
        let scheduledAt = makeScheduledAt()
        let matchID = displayData.cardItem.matchId
        let repository = repository

        confirmTask = requestRunner.run(
            operation: {
                try await repository.confirmSchedule(matchId: matchID, scheduledAt: scheduledAt)
            },
            onSuccess: { [self] _ in
                output.showBack.send(())
            },
            onFailure: { error in
                AppLogger.error(error, message: "동행 일정 확정에 실패했습니다.")
            }
        )
    }

    private func makeScheduledAt() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = scheduleTimeZone
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:00"
        return formatter.string(from: selectedDate)
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
                selectedDate = NearbyDateParser.parseLocal(displayData.scheduledAt, timeZoneID: displayData.timeZoneID) ?? Date()
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
