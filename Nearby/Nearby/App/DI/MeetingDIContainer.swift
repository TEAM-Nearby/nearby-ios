//
//  MeetingDIContainer.swift
//  Nearby
//
//  Created by soomin on 9/9/26.
//

import UIKit

final class MeetingDIContainer {
    
    // MARK: - Dependencies

    private let networkProvider: NetworkProvider
    private let eventCenter: MeetingEventCenter
    private let matchingRepository: MatchedCompanionListRepository
    private let myPageRepository: MyPageRepository

    // MARK: - Services

    private lazy var meetingService: MeetingService = DefaultMeetingService(networkProvider: networkProvider)
    private lazy var reviewService: ReviewService = DefaultReviewService(networkProvider: networkProvider)

    // MARK: - Repositories

    private lazy var meetingRepository: MeetingRepository = DefaultMeetingRepository(meetingService: meetingService)
    private lazy var reviewRepository: ReviewRepository = DefaultReviewRepository(service: reviewService)

    // MARK: - Initializer

    init(networkProvider: NetworkProvider, eventCenter: MeetingEventCenter, matchingRepository: MatchedCompanionListRepository, myPageRepository: MyPageRepository) {
        self.networkProvider = networkProvider
        self.eventCenter = eventCenter
        self.matchingRepository = matchingRepository
        self.myPageRepository = myPageRepository
    }

    // MARK: - Factory Methods

    func makeMeetingViewController(coordinator: MeetingTabCoordinator) -> UIViewController {
        let viewController = MeetingTabViewController(viewModel: MeetingTabViewModel(repository: meetingRepository, eventCenter: eventCenter))
        viewController.coordinator = coordinator
        return viewController
    }

    func makeMeetingProgressViewController(coordinator: MeetingTabCoordinator, item: MeetingItem) -> UIViewController {
        let viewModel = MeetingProgressViewModel(item: item, repository: meetingRepository, matchingRepository: matchingRepository, reviewRepository: reviewRepository)
        let viewController = MeetingProgressViewController(viewModel: viewModel)
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeReviewViewController(coordinator: MeetingTabCoordinator, type: NearbyUserType, reviewItem: ReviewItem) -> UIViewController {
        switch type {
        case .host:
            return makeHostReviewListViewController(coordinator: coordinator, meetingId: reviewItem.meetingId)
        case .participant:
            return makeReviewPostViewController(coordinator: coordinator, reviewItem: reviewItem, type: type, isLast: false, onSaved: nil)
        }
    }

    func makeHostReviewListViewController(coordinator: MeetingTabCoordinator, meetingId: Int) -> UIViewController {
        let viewModel = HostReviewListViewModel(meetingId: meetingId, repository: reviewRepository, myPageRepository: myPageRepository, eventCenter: eventCenter)
        let viewController = HostReviewListViewController(viewModel: viewModel)
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeReviewPostViewController(coordinator: MeetingTabCoordinator, reviewItem: ReviewItem, type: NearbyUserType, isLast: Bool, onSaved: (() -> Void)?) -> UIViewController {
        let viewModel = ReviewPostViewModel(reviewItem: reviewItem, type: type, isLastReview: isLast, repository: reviewRepository, eventCenter: eventCenter)
        let viewController = ReviewPostViewController(viewModel: viewModel)
        viewController.coordinator = coordinator
        viewController.onReviewSaved = onSaved
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeReportPostViewController(coordinator: MeetingTabCoordinator) -> UIViewController {
        let viewController = ReportPostViewController(viewModel: ReportPostViewModel())
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeReportCompletionViewController(coordinator: MeetingTabCoordinator) -> UIViewController {
        let viewController = ReportCompletionViewController(viewModel: EmptyViewModel())
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
}
