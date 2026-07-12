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

    private let item: MatchingMatchedCardItem

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

        case .editButtonDidTap:
            output.showEdit.send(item)

        case .shareButtonDidTap:
            output.showShare.send(())
        }
    }

    // MARK: - Method

    private func makeDisplayData() -> MatchingScheduleDetailDisplayData {
        // TODO: - 상세 일정 API
        return MatchingScheduleDetailDisplayData(
            cardItem: item,
            placeName: item.content.place,
            placeAddress: "Siutat condal, Rambla de Catalunya, 16",
            latitude: 37.566508,
            longitude: 126.977945,
            scheduledAtText: "6월 18일 (목) 오후 4시 30분",
            openChatUrl: "kakaotalk.hcmvietnam.tistory.com/36",
            type: item.type
        )
    }
}
