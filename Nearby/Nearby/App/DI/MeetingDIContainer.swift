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

    func makeMeetingViewController(onRoute: @escaping (MeetingRoute) -> Void) -> UIViewController {
        let viewController = MeetingTabViewController(viewModel: MeetingTabViewModel(repository: meetingRepository, eventCenter: eventCenter))
        viewController.onRoute = onRoute
        return viewController
    }

    func makeMeetingProgressViewController(item: MeetingItem, onRoute: @escaping (MeetingRoute) -> Void) -> UIViewController {
        let viewModel = MeetingProgressViewModel(item: item, repository: meetingRepository, matchingRepository: matchingRepository, reviewRepository: reviewRepository)
        let viewController = MeetingProgressViewController(viewModel: viewModel)
        viewController.onRoute = onRoute
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeHostReviewListViewController(meetingId: Int, onRoute: @escaping (MeetingRoute) -> Void) -> HostReviewListViewController {
        let viewModel = HostReviewListViewModel(meetingId: meetingId, repository: reviewRepository, myPageRepository: myPageRepository, eventCenter: eventCenter)
        let viewController = HostReviewListViewController(viewModel: viewModel)
        viewController.onRoute = onRoute
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeReviewPostViewController(reviewItem: ReviewItem, type: NearbyUserType, isLast: Bool, onSaved: (() -> Void)?, onRoute: @escaping (MeetingRoute) -> Void) -> UIViewController {
        let viewModel = ReviewPostViewModel(reviewItem: reviewItem, type: type, isLastReview: isLast, repository: reviewRepository, eventCenter: eventCenter)
        let viewController = ReviewPostViewController(viewModel: viewModel)
        viewController.onRoute = onRoute
        viewController.onReviewSaved = onSaved
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeReportPostViewController(onRoute: @escaping (MeetingRoute) -> Void) -> UIViewController {
        let viewController = ReportPostViewController(viewModel: ReportPostViewModel())
        viewController.onRoute = onRoute
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeReportCompletionViewController(onRoute: @escaping (MeetingRoute) -> Void) -> UIViewController {
        let viewController = ReportCompletionViewController(viewModel: EmptyViewModel())
        viewController.onRoute = onRoute
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
}
