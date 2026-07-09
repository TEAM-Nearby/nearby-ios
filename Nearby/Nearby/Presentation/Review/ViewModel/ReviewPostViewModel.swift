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
        case tagsChanged(first: Set<Int>, second: Set<Int>)
        case reportButtonDidTap
        case completionButtonDidTap
    }
    
    // MARK: - Output
    
    struct Output {
        let displayData = PassthroughSubject<DisplayData, Never>()
        let isCompletionEnabled = CurrentValueSubject<Bool, Never>(false)
        let showReport = PassthroughSubject<Void, Never>()
        let submitSuccess = PassthroughSubject<Void, Never>()
    }
    
    struct DisplayData {
        let name: String
        let information: String
    }
    
    // MARK: - Properties
    
    let output = Output()
    
    private let reviewItem: ReviewItem
    
    private var rating: Int = 0
    private var firstTags = Set<Int>()
    private var secondTags = Set<Int>()
    
    // MARK: - Initializer
    
    init(reviewItem: ReviewItem) {
        self.reviewItem = reviewItem
    }
    
    // MARK: - Methods
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            output.displayData.send(
                DisplayData(name: reviewItem.name, information: reviewItem.information)
            )
            
        case .ratingChanged(let value):
            rating = value
            updateCompletionState()
            
        case .tagsChanged(let first, let second):
            firstTags = first
            secondTags = second
            updateCompletionState()
            
        case .reportButtonDidTap:
            output.showReport.send(())
            
        case .completionButtonDidTap:
            guard rating > 0, !firstTags.isEmpty && !secondTags.isEmpty else { return }
            // TODO: - 후기 등록 API 연동 (rating, firstTags, secondTags, reviewItem.id)
            output.submitSuccess.send(())
        }
    }
    
    private func updateCompletionState() {
        let hasRating = rating > 0
            let hasTag = !firstTags.isEmpty || !secondTags.isEmpty
            output.isCompletionEnabled.send(hasRating && hasTag)
    }
}
