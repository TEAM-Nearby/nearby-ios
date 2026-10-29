//
//  HostReviewListViewModel.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import Combine
import UIKit

final class HostReviewListViewModel: BaseViewModelType, RequestRunning {
    let requestRunner = RequestRunner()
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case viewWillAppear
        case viewDidDisappear
        case refreshNotifications
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
        let hasUnreadNotifications = CurrentValueSubject<Bool, Never>(false)
    }
    
    struct HeaderInfo {
        let people: String
        let information: String
        let location: String
        let avatarImageUrls: [String?]
    }
    
    // MARK: - Properties

    let output = Output()

    private let meeting: ReviewMeetingInfo
    private let repository: ReviewRepository
    private let myPageRepository: MyPageRepository
    private let notificationChecker: UnreadNotificationChecker
    private let eventCenter: MeetingEventCenter

    private var cancellables = Set<AnyCancellable>()
    private var notificationTask: Task<Void, Never>?
    private var isCompleting = false

    var items: [ReviewItem] { output.items.value }

    private var remainingItems: [ReviewItem] {
        items.filter { !output.reviewedIDs.value.contains($0.id) }
    }

    // MARK: - Initializer

    init(meeting: ReviewMeetingInfo, repository: ReviewRepository, myPageRepository: MyPageRepository, notificationRepository: CompanionRequestRepository, eventCenter: MeetingEventCenter) {
        self.meeting = meeting
        self.repository = repository
        self.myPageRepository = myPageRepository
        self.notificationChecker = UnreadNotificationChecker(repository: notificationRepository)
        self.eventCenter = eventCenter
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchReviewTargets()

        case .viewWillAppear, .refreshNotifications:
            refreshNotifications()

        case .viewDidDisappear:
            notificationTask?.cancel()

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
                async let myPage = myPageRepository.fetchMyPage()
                let reviewTargets = try await repository.fetchReviewTargets(meetingId: meeting.meetingId)
                let reviewees = reviewTargets.reviewees
                let myProfileImageUrl = (try? await myPage)?.profileImageUrl

                if let first = reviewees.first {
                    let people = reviewees.count == 1
                        ? "\(first.nickname.displayNickname) 님과의 동행"
                        : "\(first.nickname.displayNickname) 외 \(reviewees.count - 1)명과의 동행"
                    output.headerInfo.send(
                        HeaderInfo(
                            people: people,
                            information: ReviewItem.makeInformation(cityName: meeting.cityName, dateText: first.meetingDisplayDate),
                            location: meeting.placeName,
                            avatarImageUrls: [myProfileImageUrl] + reviewees.map(\.profileImageURL)
                        )
                    )
                }

                output.reviewedIDs.send(Set(reviewees.filter(\.hasWrittenReview).map(\.userID)))
                output.items.send(reviewees.map { ReviewItem(reviewee: $0, meeting: meeting) })
            } catch {
                AppLogger.error(error)
            }
        }
    }
    
    private func refreshNotifications() {
        notificationTask?.cancel()
        notificationTask = Task { [weak self] in
            guard let self, let hasUnread = await notificationChecker.hasUnread() else { return }
            output.hasUnreadNotifications.send(hasUnread)
        }
    }

    private func completeMeeting() {
        guard !isCompleting else { return }

        requestRunner.run(
            onStart: { [self] in
                isCompleting = true
            },
            operation: { [self] in
                try await repository.completeMeeting(meetingId: meeting.meetingId)
            },
            onSuccess: { [self] completion in
                eventCenter.notifyCompleted(matchId: completion.matchID)
                output.showCompletion.send(())
            },
            onFailure: { error in
                AppLogger.error(error)
            },
            onFinish: { [self] in
                isCompleting = false
            }
        )
    }
}
