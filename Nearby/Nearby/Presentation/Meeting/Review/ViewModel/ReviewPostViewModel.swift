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
        let errorMessage = PassthroughSubject<String, Never>()
    }
    
    struct DisplayData {
        let name: String
        let information: String
        let buttonTitle: String
    }
    
    // MARK: - Properties
    
    let firstTagTitles = ReviewKeyword.consideration.map(\.displayText)
    let secondTagTitles = ReviewKeyword.timePromise.map(\.displayText)

    private(set) var firstSelectedTags = Set<Int>()
    private(set) var secondSelectedTags = Set<Int>()

    let output = Output()
    private let reviewItem: ReviewItem
    private let type: NearbyUserType
    private let isLastReview: Bool
    private let repository: ReviewRepository
    private var rating: Int = 0

    private var isFinishButton: Bool {
        type == .participant || isLastReview
    }

    private var hasReviewContent: Bool {
        rating > 0 && !firstSelectedTags.isEmpty && !secondSelectedTags.isEmpty
    }

    // MARK: - Initializer

    init(reviewItem: ReviewItem, type: NearbyUserType, isLastReview: Bool, repository: ReviewRepository) {
        self.reviewItem = reviewItem
        self.type = type
        self.isLastReview = isLastReview
        self.repository = repository
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
            if hasReviewContent {
                submitReview()
            } else if isFinishButton {
                completeMeeting()
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
        output.isCompletionEnabled.send(isFinishButton ? true : hasReviewContent)
    }

    private func submitReview() {
        Task {
            do {
                let keywords = firstSelectedTags.sorted().map { ReviewKeyword.consideration[$0].rawValue }
                    + secondSelectedTags.sorted().map { ReviewKeyword.timePromise[$0].rawValue }
                let request = CreateReviewRequestDTO(
                    revieweeUserId: reviewItem.revieweeUserId,
                    rating: rating,
                    keywords: keywords
                )
                _ = try await repository.createReview(meetingId: reviewItem.meetingId, request: request)

                if isFinishButton {
                    _ = try await repository.completeMeeting(meetingId: reviewItem.meetingId)
                    output.companionCompleted.send(())
                } else {
                    output.reviewSaved.send(())
                }
            } catch {
                AppLogger.error(error)
                output.errorMessage.send(error.localizedDescription)
            }
        }
    }
    
    private func completeMeeting() {
        Task {
            do {
                _ = try await repository.completeMeeting(meetingId: reviewItem.meetingId)
                output.companionCompleted.send(())
            } catch {
                AppLogger.error(error)
                output.errorMessage.send(error.localizedDescription)
            }
        }
    }
}
