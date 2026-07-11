//
//  WrittenPostViewModel.swift
//  Nearby
//
//  Created by 신서연 on 7/11/26.
//

import Foundation

final class WrittenPostViewModel:
    BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case backButtonDidTap
        case findCompanionButtonDidTap
    }

    // MARK: - Output

    struct Output {
        var writtenPostItems: (([WrittenPostItem]) -> Void)?
        var backButtonDidTap: (() -> Void)?
        var findCompanionButtonDidTap: (() -> Void)?
    }

    // MARK: - Properties

    var output = Output()

    private var writtenPostItems: [WrittenPostItem] = [
        WrittenPostItem(
            cityName: "바르셀로나",
            createdDateText: "2026.10.28",
            placeName: "Ciudad Condal",
            latitude: 41.3894,
            longitude: 2.1677,
            placeID: nil,
            meetingDateText: "6월 18일 (목) 오후 4시 30분",
            currentPeopleCount: 3,
            maximumPeopleCount: 4,
            content: """
            같이 스시 먹으러 갈 사람~~여기 제가 정말 좋아하는 스시집인데 혼자 먹기는 양이 너무 많아서 동행 구해봐요 같은 동성이면 더 좋을 것 같아요 밥 먹고 카페까지 같이 가면 좋을 것 같습니다 저는 친구 한 명과 같이 왔어요!
            """,
            keywords: [
                "시간을 잘지켜요",
                "매너가 좋아요",
                "연락이 빨라요"
            ]
        ),
        WrittenPostItem(
            cityName: "바르셀로나",
            createdDateText: "2026.10.28",
            placeName: "Ciudad Condal",
            latitude: 41.3894,
            longitude: 2.1677,
            placeID: nil,
            meetingDateText: "6월 18일 (목) 오후 4시 30분",
            currentPeopleCount: 3,
            maximumPeopleCount: 4,
            content: """
            같이 맛있는 음식을 먹고 여행 이야기를 나눌 분을 찾고 있어요. 편안하게 대화하면서 즐거운 시간을 보내면 좋겠습니다!
            """,
            keywords: [
                "시간을 잘지켜요",
                "매너가 좋아요",
                "연락이 빨라요"
            ]
        )
    ]

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            output.writtenPostItems?(writtenPostItems)

        case .backButtonDidTap:
            output.backButtonDidTap?()

        case .findCompanionButtonDidTap:
            output.findCompanionButtonDidTap?()
        }
    }
}
