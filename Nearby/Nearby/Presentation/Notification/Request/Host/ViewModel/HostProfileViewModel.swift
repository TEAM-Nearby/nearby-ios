//
//  HostProfileViewModel.swift
//  Nearby
//
//  Created by 신서연 on 7/12/26.
//

import Combine
import UIKit

final class HostProfileViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case communicationChipDidTap(index: Int)
        case punctualityChipDidTap(index: Int)
        case backButtonDidTap
    }

    // MARK: - Output

    struct Output {
        let displayData = PassthroughSubject<DisplayData, Never>()
        let selectedReviewState = PassthroughSubject<SelectedReviewState, Never>()
        let backButtonDidTap = PassthroughSubject<Void, Never>()
    }

    struct DisplayData {
        let profileImage: UIImage?
        let nickname: String
        let gender: String
        let personalityKeywords: [String]
        let mannerScore: Int
        let introduction: String
        let communicationKeywords: [String]
        let punctualityKeywords: [String]
    }

    struct SelectedReviewState {
        let selectedCommunicationIndexes: Set<Int>
        let selectedPunctualityIndexes: Set<Int>
    }

    // MARK: - Properties

    let output = Output()

    private var selectedCommunicationIndexes = Set<Int>()
    private var selectedPunctualityIndexes = Set<Int>()

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            sendDisplayData()
            sendSelectedReviewState()

        case let .communicationChipDidTap(index):
            toggleCommunicationChip(at: index)

        case let .punctualityChipDidTap(index):
            togglePunctualityChip(at: index)

        case .backButtonDidTap:
            output.backButtonDidTap.send(())
        }
    }
}

// MARK: - Private Methods

private extension HostProfileViewModel {

    func sendDisplayData() {
        let displayData = DisplayData(
            profileImage: .imgProfileDefault,
            nickname: "조예원",
            gender: "여성",
            personalityKeywords: [
                "내향형",
                "외향형",
                "밝은",
                "새벽형",
                "대화 좋아",
                "자연힐링"
            ],
            mannerScore: 4,
            introduction:
            """
            본인 소개글
            본인 소개글본인 소개글
            본인 소개글
            """,
            communicationKeywords: [
                "연락이 빨라요",
                "매너가 좋아요",
                "친절하고 다정해요",
                "대화가 잘 통해요"
            ],
            punctualityKeywords: [
                "시간 약속을 잘 지켜요",
                "늦어도 미리 알려줘요",
                "약속 시간보다 일찍 와요"
            ]
        )

        output.displayData.send(displayData)
    }

    func toggleCommunicationChip(at index: Int) {
        if selectedCommunicationIndexes.contains(index) {
            selectedCommunicationIndexes.remove(index)
        } else {
            selectedCommunicationIndexes.insert(index)
        }

        sendSelectedReviewState()
    }

    func togglePunctualityChip(at index: Int) {
        if selectedPunctualityIndexes.contains(index) {
            selectedPunctualityIndexes.remove(index)
        } else {
            selectedPunctualityIndexes.insert(index)
        }

        sendSelectedReviewState()
    }

    func sendSelectedReviewState() {
        let state = SelectedReviewState(
            selectedCommunicationIndexes: selectedCommunicationIndexes,
            selectedPunctualityIndexes: selectedPunctualityIndexes
        )

        output.selectedReviewState.send(state)
    }
}
