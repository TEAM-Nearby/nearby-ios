//
//  HostReviewListViewModel.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import Combine
import UIKit

final class HostReviewListViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case profileDidTap(ReviewItem)
        case reviewSaved(ReviewItem)
        case completionButtonDidTap
    }
    
    // MARK: - Output
    
    struct Output {
        let headerInfo = PassthroughSubject<HeaderInfo, Never>()
        let items = CurrentValueSubject<[ReviewItem], Never>([])
        let showReviewWrite = PassthroughSubject<(item: ReviewItem, isLast: Bool), Never>()
        let showCompletion = PassthroughSubject<Void, Never>()
        let reviewedIDs = CurrentValueSubject<Set<Int>, Never>([])
        let errorMessage = PassthroughSubject<String, Never>()
    }
    
    struct HeaderInfo {
        let people: String
        let information: String
        let location: String
        let avatarImages: [UIImage?]
    }
    
    // MARK: - Properties

    let output = Output()

    private let meetingId: Int
    private let repository: ReviewRepository
    private let eventCenter: MeetingEventCenter
    
    private var cancellables = Set<AnyCancellable>()
    private var isCompleting = false
    
    var items: [ReviewItem] { output.items.value }

    private var remainingItems: [ReviewItem] {
        items.filter { !output.reviewedIDs.value.contains($0.id) }
    }

    // MARK: - Initializer

    init(meetingId: Int, repository: ReviewRepository, eventCenter: MeetingEventCenter) {
        self.meetingId = meetingId
        self.repository = repository
        self.eventCenter = eventCenter
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchReviewTargets()

        case .profileDidTap(let item):
            guard !output.reviewedIDs.value.contains(item.id) else { return }
            let isLast = remainingItems.count == 1 && remainingItems.first?.id == item.id
            output.showReviewWrite.send((item, isLast))
            
        case .reviewSaved(let item):
            var reviewed = output.reviewedIDs.value
            reviewed.insert(item.id)
            output.reviewedIDs.send(reviewed)
            
        case .completionButtonDidTap:
            completeMeeting()
        }
    }
    
    // MARK: - Methods

    private func fetchReviewTargets() {
        Task {
            do {
                let DTO = try await repository.fetchReviewTargets(meetingId: meetingId)
                let targets = DTO.reviewTargets

                if let first = targets.first {
                    let people = targets.count == 1
                        ? "\(first.nickname) 님과의 동행"
                        : "\(first.nickname) 외 \(targets.count - 1)명과의 동행"
                    output.headerInfo.send(
                        HeaderInfo(
                            people: people,
                            information: first.meetingDisplayDate,
                            location: first.cityName,
                            avatarImages: [UIImage?](repeating: .imgProfileDefault, count: targets.count)
                        )
                    )
                }

                output.reviewedIDs.send(Set(targets.filter(\.hasWrittenReview).map(\.revieweeUserId)))
                output.items.send(targets.map { ReviewItem(target: $0, meetingId: meetingId) })
            } catch {
                AppLogger.error(error)
                output.errorMessage.send(error.localizedDescription)
            }
        }
    }
    
    private func completeMeeting() {
        guard !isCompleting else { return }
        isCompleting = true
        Task {
            defer { isCompleting = false }
            do {
                let response = try await repository.completeMeeting(meetingId: meetingId)
                eventCenter.meetingCompleted.send(response.matchId)
                output.showCompletion.send(())
            } catch {
                AppLogger.error(error)
                output.errorMessage.send(error.localizedDescription)
            }
        }
    }
    
    func item(at index: Int) -> ReviewItem {
        items[index]
    }
}
