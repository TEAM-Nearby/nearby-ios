//
//  SpecificCompanionBottomSheetViewModel.swift
//  Nearby
//
//  Created by soomin on 7/9/26.
//

import Combine

final class SpecificCompanionBottomSheetViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {}
    
    // MARK: - Output
    
    struct Output {
        let companions: CurrentValueSubject<[SpecificCompanionCellItem], Never>
    }
    
    // MARK: - Properties
    
    let output: Output
    
    var companionCount: Int {
        output.companions.value.count
    }
    
    // MARK: - Initializer
    
    init(companions: [SpecificCompanionCellItem] = SpecificCompanionBottomSheetViewModel.mockSpecificCompanions) {
        self.output = Output(companions: CurrentValueSubject(companions))
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {}
    
    func companion(at index: Int) -> SpecificCompanionCellItem {
        output.companions.value[index]
    }
}

private extension SpecificCompanionBottomSheetViewModel {
    static let mockSpecificCompanions: [SpecificCompanionCellItem] = [
        SpecificCompanionCellItem(
            profileImage: nil,
            hostName: "조예원",
            genderTitle: "여성",
            writtenTime: "30분 전",
            content: "같이 스시 먹으러 갈 사람~~여기 제가 정말 좋아하는 스시집인데 혼자 먹기는 양이 너무 많아서 동행 구해봐요",
            meetingTime: "오후 4시 30분",
            closedTime: " | 마감 2시간 전",
            participantImages: [nil, nil],
            statusText: "2/4 모집 중"
        ),
        SpecificCompanionCellItem(
            profileImage: nil,
            hostName: "정지영",
            genderTitle: "여성",
            writtenTime: "1시간 전",
            content: "같이 스시 먹으러 갈 사람~~여기 제가 정말 좋아하는 스시집인데 혼자 먹기는 양이 너무 많아서 동행 구해봐요",
            meetingTime: "오후 4시 30분",
            closedTime: " | 마감 20분 전",
            participantImages: [nil, nil],
            statusText: "2/4 모집 중"
        ),
        SpecificCompanionCellItem(
            profileImage: nil,
            hostName: "조예원",
            genderTitle: "여성",
            writtenTime: "30분 전",
            content: "같이 스시 먹으러 갈 사람~~여기 제가 정말 좋아하는 스시집인데 혼자 먹기는 양이 너무 많아서 동행 구해봐요",
            meetingTime: "지금 바로",
            closedTime: "",
            participantImages: [nil, nil, nil],
            statusText: "3/4 모집 중"
        ),
        SpecificCompanionCellItem(
            profileImage: nil,
            hostName: "정지영",
            genderTitle: "여성",
            writtenTime: "1시간 전",
            content: "같이 스시 먹으러 갈 사람~~여기 제가 정말 좋아하는 스시집인데 혼자 먹기는 양이 너무 많아서 동행 구해봐요",
            meetingTime: "오후 4시 30분",
            closedTime: " | 마감 20분 전",
            participantImages: [nil, nil],
            statusText: "2/4 모집 중"
        )
    ]
}
