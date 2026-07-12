//
//  MatchingViewModel.swift
//  Nearby
//
//  Created by 장지인 on 7/11/26.
//

import Combine
import Foundation

final class MatchingViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case cardDidTap(Int)
        case alarmButtonDidTap
        case findCompanionButtonDidTap
    }

    // MARK: - Output

    struct Output {
        let items = CurrentValueSubject<[MatchingMatchedCardItem], Never>([])
        let showScheduleDetail = PassthroughSubject<MatchingMatchedCardItem, Never>()
        let showAlarm = PassthroughSubject<Void, Never>()
        let showCompanionTab = PassthroughSubject<Void, Never>()
    }

    // MARK: - Properties

    let output = Output()

    var items: [MatchingMatchedCardItem] {
        return output.items.value
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            // TODO: - 매칭 목록 조회 API 응답으로 교체
            output.items.send(Self.mockItems)

        case .cardDidTap(let index):
            guard items.indices.contains(index) else { return }
            output.showScheduleDetail.send(items[index])

        case .alarmButtonDidTap:
            output.showAlarm.send(())

        case .findCompanionButtonDidTap:
            output.showCompanionTab.send(())
        }
    }

    // MARK: - Method

    func item(at index: Int) -> MatchingMatchedCardItem {
        return items[index]
    }
}

private extension MatchingViewModel {
    static let mockItems: [MatchingMatchedCardItem] = [
        MatchingMatchedCardItem.sample,
        MatchingMatchedCardItem(
            matchId: 1,
            content: MatchingMatchedCardContentModel(
                name: "정지영",
                participantCount: 2,
                gender: "여성",
                uploadedTime: "15분 전 올림",
                place: "시우다드 콘달",
                meetingTime: "오후 4:30",
                description: "오늘 저녁 바르셀로나에서 같이 타파스 드실 분..."
            ),
            matchStatus: "MATCHED",
            type: .participant
        )
    ]
}
