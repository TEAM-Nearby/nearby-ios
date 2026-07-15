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
    private let matchId: Int?
    private var selectedDate = Date()

    // MARK: - Initializer

    init(displayData: MatchingScheduleDetailDisplayData, repository: MatchedCompanionListRepository) {
        self.displayData = displayData
        self.repository = repository
        self.selectedDate = displayData.scheduledAt?.apiDate ?? Date()
        self.matchId = nil
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
        self.matchId = nil
        self.repository = repository
    }
    
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

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            if matchId != nil {
                fetchDisplayData()
            } else {
                output.displayData.send(makeDisplayData())
            }

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
        guard let request = makeRequestDTO() else { return }

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

    private func makeRequestDTO() -> ConfirmCompanionScheduleRequestDTO? {
        guard let googlePlaceId = displayData.googlePlaceId else {
            AppLogger.error(
                AppError.apiError(message: "동행 일정 확정에 필요한 장소 ID가 없습니다.")
            )
            return nil
        }

        return ConfirmCompanionScheduleRequestDTO(
            scheduledAt: selectedDate.apiDateString,
            place: ConfirmCompanionScheduleRequestDTO.Place(
                googlePlaceId: googlePlaceId,
                name: displayData.placeName,
                address: displayData.placeAddress,
                latitude: displayData.latitude,
                longitude: displayData.longitude
            ),
            openChatUrl: displayData.openChatUrl
        )
    }
    
    private func fetchDisplayData() {
        Task { @MainActor [weak self] in
            guard let self, let matchId else { return }

            do {
                async let scheduleResponseTask = repository.fetchMatchMySchedule(matchId: matchId)
                async let previewResponseTask = repository.fetchMatchPreview(matchId: matchId)

                let scheduleResponse = try await scheduleResponseTask
                let previewResponse = try? await previewResponseTask
                let currentUserRole = scheduleResponse.currentUserRole
                let cardItem = previewResponse?.toCardItem(
                    type: currentUserRole,
                    matchStatus: scheduleResponse.matchStatus.rawValue,
                    fallbackPlaceName: scheduleResponse.schedule?.place.name ?? ""
                ) ?? scheduleResponse.toCardItem(type: currentUserRole)

                displayData = scheduleResponse.toDisplayData(type: currentUserRole, cardItem: cardItem)
                selectedDate = displayData.scheduledAt?.apiDate ?? Date()
                output.displayData.send(makeDisplayData())
            } catch {
                AppLogger.error(error, message: "매칭 상세 조회에 실패했습니다.")
            }
        }
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
