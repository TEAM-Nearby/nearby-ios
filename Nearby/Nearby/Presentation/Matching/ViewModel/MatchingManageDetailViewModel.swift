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
        let submitSchedule = PassthroughSubject<MatchingManageScheduleRequestModel, Never>()
    }

    struct DisplayData {
        let cardItem: MatchingMatchedCardItem
        let placeAddress: String
        let latitude: Double
        let longitude: Double
        let selectedDate: Date
        let dateButtonTitle: String
    }

    // MARK: - Properties

    let output = Output()

    private let item: MatchingMatchedCardItem
    private var selectedDate = Date()

    // MARK: - Initializer

    init(item: MatchingMatchedCardItem) {
        self.item = item
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
            output.submitSchedule.send(makeRequestModel())
        }
    }

    // MARK: - Method

    private func makeDisplayData() -> DisplayData {
        return DisplayData(
            cardItem: item,
            placeAddress: "Siutat condal, Rambla de Catalunya, 16",
            latitude: 37.566508,
            longitude: 126.977945,
            selectedDate: selectedDate,
            dateButtonTitle: selectedDate.displayDateString
        )
    }

    private func makeRequestModel() -> MatchingManageScheduleRequestModel {
        return MatchingManageScheduleRequestModel(
            scheduledAt: selectedDate.apiDateString,
            place: MatchingManageSchedulePlaceRequestModel(
                googlePlaceId: "",
                name: item.content.place,
                address: "Siutat condal, Rambla de Catalunya, 16",
                latitude: 37.566508,
                longitude: 126.977945
            ),
            openChatUrl: "kakaotalk.hcmvietnam.tistory.com/36"
        )
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
