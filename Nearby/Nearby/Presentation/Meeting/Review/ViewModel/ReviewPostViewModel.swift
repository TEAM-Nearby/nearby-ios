//
//  ReviewPostViewModel.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import Combine
import Foundation

final class ReviewPostViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case ratingChanged(Int)
        case firstTagTapped(Int)
        case secondTagTapped(Int)
        case reportButtonDidTap
        case completionButtonDidTap
    }
    
    // MARK: - Output
    
    struct Output {
        let displayData = PassthroughSubject<DisplayData, Never>()
        let reloadFirstTags = PassthroughSubject<[Int], Never>()
        let reloadSecondTags = PassthroughSubject<[Int], Never>()
        let isCompletionEnabled = CurrentValueSubject<Bool, Never>(false)
        let showReport = PassthroughSubject<Void, Never>()
        let reviewSaved = PassthroughSubject<Void, Never>()
        let companionCompleted = PassthroughSubject<Void, Never>()
    }
    
    struct DisplayData {
        let name: String
        let information: String
        let buttonTitle: String
    }
    
    // MARK: - Properties
    
    let firstTagTitles = [
        "연락이 빨라요", "매너가 좋아요", "대화가 잘 통해요",
        "입담이 좋아요", "유용한 정보를 많이 알아요"
    ]
    let secondTagTitles = [
        "시간 약속을 잘 지켜요", "늦어도 미리 알려줘요",
        "약속 시간보다 일찍 와요"
    ]
    
    private(set) var firstSelectedTags = Set<Int>()
    private(set) var secondSelectedTags = Set<Int>()
    
    let output = Output()
    private let reviewItem: ReviewItem
    private let type: NearbyUserType
    private let isLastReview: Bool
    private var rating: Int = 0

    private var isFinishButton: Bool {
        type == .participant || isLastReview
    }
    
    // MARK: - Initializer
    
    init(reviewItem: ReviewItem, type: NearbyUserType, isLastReview: Bool) {
        self.reviewItem = reviewItem
        self.type = type
        self.isLastReview = isLastReview
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            output.displayData.send(
                DisplayData(
                    name: reviewItem.name,
                    information: reviewItem.information,
                    buttonTitle: isFinishButton ? "동행 마치기" : "후기 저장하기"
                )
            )
            updateCompletionState()
            
        case .ratingChanged(let value):
            rating = value
            updateCompletionState()
            
        case .firstTagTapped(let index):
            let changed = toggleFirstTag(index)
            output.reloadFirstTags.send(changed)
            updateCompletionState()
            
        case .secondTagTapped(let index):
            let changed = toggleSecondTag(index)
            output.reloadSecondTags.send(changed)
            updateCompletionState()
            
        case .reportButtonDidTap:
            output.showReport.send(())
            
        case .completionButtonDidTap:
            guard output.isCompletionEnabled.value else { return }
            // TODO: - 내용이 있으면 후기 등록 API, isFinishButton이면 동행 완료 API 연동
            if isFinishButton {
                output.companionCompleted.send(())
            } else {
                output.reviewSaved.send(())
            }
        }
    }
    
    // MARK: - Methods
    
    private func toggleFirstTag(_ index: Int) -> [Int] {
        if firstSelectedTags.contains(index) {
            firstSelectedTags.remove(index)
        } else {
            guard firstSelectedTags.count < 3 else { return [] }
            firstSelectedTags.insert(index)
        }
        return [index]
    }
    
    private func toggleSecondTag(_ index: Int) -> [Int] {
        let previous = secondSelectedTags
        secondSelectedTags = secondSelectedTags.contains(index) ? [] : [index]
        return Array(previous.union(secondSelectedTags))
    }
    
    private func updateCompletionState() {
        let hasContent = rating > 0 && !firstSelectedTags.isEmpty && !secondSelectedTags.isEmpty
        output.isCompletionEnabled.send(isFinishButton ? true : hasContent)
    }
}
