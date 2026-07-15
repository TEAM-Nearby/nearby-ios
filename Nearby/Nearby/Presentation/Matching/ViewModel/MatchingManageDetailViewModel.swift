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

    private let displayData: MatchingScheduleDetailDisplayData
    private let repository: MatchedCompanionListRepository
    private var selectedDate = Date()

    // MARK: - Initializer

    init(displayData: MatchingScheduleDetailDisplayData, repository: MatchedCompanionListRepository) {
        self.displayData = displayData
        self.repository = repository
        self.selectedDate = displayData.scheduledAt?.apiDate ?? Date()
    }

    init(item: MatchingMatchedCardItem, repository: MatchedCompanionListRepository) {
        self.displayData = MatchingScheduleDetailDisplayData(
            cardItem: item,
            placeName: item.content.place,
            placeAddress: "",
            googlePlaceId: nil,
            latitude: 0,
            longitude: 0,
            scheduledAt: nil,
            scheduledAtText: item.content.meetingTime,
            openChatUrl: "",
            type: item.type
        )
        self.repository = repository
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            output.displayData.send(makeDisplayData())

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

    // MARK: - Method

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
        let request = makeRequestDTO()

        Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                _ = try await repository.confirmSchedule(matchId: displayData.cardItem.matchId, request: request)
                output.showBack.send(())
            } catch {
                AppLogger.error(error, message: "동행 일정 확정에 실패했습니다.")
            }
        }
    }

    private func makeRequestDTO() -> ConfirmCompanionScheduleRequestDTO {
        return ConfirmCompanionScheduleRequestDTO(scheduledAt: selectedDate.apiDateString)
    }
}

private extension String {
    var apiDate: Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: self)
    }
}

private extension Date {
    var displayDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd  HH:mm"
        return formatter.string(from: self)
    }

    var apiDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.string(from: self)
    }
}
