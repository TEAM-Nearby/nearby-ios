//
//  NearCompanionBottomSheetViewModel.swift
//  Nearby
//
//  Created by soomin on 7/9/26.
//

import Combine

final class NearCompanionBottomSheetViewModel: BaseViewModelType {
    
    // MARK: - Input

    enum Input {
        case sortOptionDidTap(SortOption)
        case companionDidSelect(Int)
    }

    // MARK: - Output

    struct Output {
        let sortOptions: [SortOption]
        let selectedSortOption = CurrentValueSubject<SortOption, Never>(.latest)
        let companions: CurrentValueSubject<[NearCompanionCellItem], Never>
        let selectedCompanion = PassthroughSubject<NearCompanionCellItem, Never>()
    }

    // MARK: - Properties

    let output: Output

    var nearCompanionCount: Int {
        output.companions.value.count
    }
    
    // MARK: - Initializer
    
    init(companions: [NearCompanionCellItem] = NearCompanionBottomSheetViewModel.mockNearCompanions) {
        self.output = Output(
            sortOptions: SortOption.allCases,
            companions: CurrentValueSubject(companions)
        )
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .sortOptionDidTap(let option):
            output.selectedSortOption.send(option)
        case .companionDidSelect(let index):
            output.selectedCompanion.send(companion(at: index))
        }
    }
    
    func companion(at index: Int) -> NearCompanionCellItem {
        output.companions.value[index]
    }
}

private extension NearCompanionBottomSheetViewModel {
    static let mockNearCompanions: [NearCompanionCellItem] = [
        NearCompanionCellItem(
            placeImage: .restaurantPlaceholder,
            placeName: "손오공 마라탕",
            writtenTime: "30분 전",
            content: "같이 스시 먹으러 갈 사람~~여기 제가 정말 좋아하는 스시집인데 가격은 조금 비싸지만...",
            schedule: "6월 29일 14:00",
            participantImages: [nil, nil],
            statusText: "2/4 모집 중"
        ),
        NearCompanionCellItem(
            placeImage: .restaurantPlaceholder,
            placeName: "스시스시",
            writtenTime: "1시간 전",
            content: "같이 스시 먹으러 갈 사람~~여기 제가 정말 좋아하는 스시집인데 가격은 조금 비싸지만...",
            schedule: "6월 29일 18:30",
            participantImages: [nil, nil, nil],
            statusText: "3/4 모집 중"
        ),
        NearCompanionCellItem(
            placeImage: .restaurantPlaceholder,
            placeName: "손오공 마라탕",
            writtenTime: "30분 전",
            content: "같이 스시 먹으러 갈 사람~~여기 제가 정말 좋아하는 스시집인데 가격은 조금 비싸지만...",
            schedule: "6월 29일 14:00",
            participantImages: [nil, nil],
            statusText: "2/4 모집 중"
        ),
        NearCompanionCellItem(
            placeImage: .restaurantPlaceholder,
            placeName: "스시스시",
            writtenTime: "1시간 전",
            content: "같이 스시 먹으러 갈 사람~~여기 제가 정말 좋아하는 스시집인데 가격은 조금 비싸지만...",
            schedule: "6월 29일 18:30",
            participantImages: [nil, nil, nil],
            statusText: "3/4 모집 중"
        )
    ]
}
