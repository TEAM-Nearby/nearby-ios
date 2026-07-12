//
//  AppDIContainer.swift
//  Nearby
//
//  Created by soomin on 7/5/26.
//

import UIKit

final class AppDIContainer {

    // MARK: - Coordinators

    func makeAppCoordinator(window: UIWindow) -> AppCoordinator {
        AppCoordinator(window: window, diContainer: self)
    }

    func makeMainTabCoordinator() -> MainTabCoordinator {
        MainTabCoordinator(diContainer: self)
    }

    func makeMeetingCoordinator(navigationController: UINavigationController) -> MeetingTabCoordinator {
        MeetingTabCoordinator( navigationController: navigationController, diContainer: self)
    }

    func makeCompanionCoordinator(navigationController: UINavigationController) -> CompanionCoordinator {
        CompanionCoordinator( navigationController: navigationController, diContainer: self)
    }
    
    func makeDiningMapCoordinator(navigationController: UINavigationController) -> DiningMapCoordinator {
        DiningMapCoordinator( navigationController: navigationController, diContainer: self)
    }
    
    func makeMatchingCoordinator(navigationController: UINavigationController) -> MatchingCoordinator {
        MatchingCoordinator(navigationController: navigationController, diContainer: self)
    }
    
    func makeMyPageCoordinator(navigationController: UINavigationController) -> MyPageCoordinator {
        MyPageCoordinator( navigationController: navigationController, appDIContainer: self)
    }

    // MARK: - Networks

    // MARK: - Repositories

    // MARK: - ViewModels

    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel()
    }

    func makeCompanionViewModel() -> CompanionViewModel {
        CompanionViewModel()
    }

    func makeDiningMapViewModel() -> DiningMapViewModel {
        DiningMapViewModel()
    }

    func makeNearDiningBottomSheetViewModel() -> NearDiningBottomSheetViewModel {
        NearDiningBottomSheetViewModel()
    }

    func makeSaveDiningSheetViewModel() -> SaveDiningSheetViewModel {
        SaveDiningSheetViewModel()
    }

    func makeCompanionDetailViewModel(state: CompanionDetailState) -> CompanionDetailViewModel {
        CompanionDetailViewModel(state: state)
    }

    func makeNearCompanionSheetViewModel() -> NearCompanionSheetViewModel {
        NearCompanionSheetViewModel()
    }

    func makeSpecificCompanionSheetViewModel() -> SpecificCompanionSheetViewModel {
        SpecificCompanionSheetViewModel()
    }

    func makeMeetingViewModel() -> MeetingTabViewModel {
        MeetingTabViewModel()
    }

    func makeMatchingViewModel() -> MatchingViewModel {
        MatchingViewModel()
    }

    func makeMeetingProgressViewModel(item: MeetingItem) -> MeetingProgressViewModel {
        MeetingProgressViewModel(item: item)
    }

    func makeMyPageViewModel() -> MyPageViewModel {
        MyPageViewModel()
    }

    func makeAlarmViewModel() -> AlarmViewModel {
        AlarmViewModel()
    }

    func makeSettingViewModel() -> SettingViewModel {
        SettingViewModel()
    }

    func makeWrittenPostViewModel() -> WrittenPostViewModel {
        WrittenPostViewModel()
    }

    func makeHostReviewListViewModel() -> HostReviewListViewModel {
        HostReviewListViewModel()
    }

    func makeReportPostViewModel() -> ReportPostViewModel {
        ReportPostViewModel()
    }

    func makeReviewPostViewModel(reviewItem: ReviewItem, type: NearbyUserType, isLast: Bool) -> ReviewPostViewModel {
        ReviewPostViewModel(reviewItem: reviewItem, type: type, isLastReview: isLast)
    }

    func makeCompanionRequestSentViewModel(hostName: String) -> CompanionRequestSentViewModel {
        CompanionRequestSentViewModel(hostName: hostName)
    }

    func makeCompanionRequestDeclineViewModel() -> CompanionRequestDeclineViewModel {
        CompanionRequestDeclineViewModel()
    }

    func makeHostRequestDeclineViewModel(applicantName: String) -> HostRequestDeclineViewModel {
        HostRequestDeclineViewModel(applicantName: applicantName)
    }
    
    // MARK: - ViewControllers

    func makeLoginViewController() -> LoginViewController {
        LoginViewController(viewModel: makeLoginViewModel())
    }

    func makeCompanionViewController(viewModel: CompanionViewModel) -> CompanionViewController {
        CompanionViewController(viewModel: viewModel,
            nearbySheetViewController: makeNearCompanionSheetViewController(),
            specificSheetViewController: makeSpecificCompanionSheetViewController(),
            emptySheetViewController: makeEmptyCompanionSheetViewController()
        )
    }

    func makeNearCompanionSheetViewController() -> NearCompanionSheetViewController {
        NearCompanionSheetViewController(viewModel: makeNearCompanionSheetViewModel())
    }

    func makeSpecificCompanionSheetViewController() -> SpecificCompanionSheetViewController {
        SpecificCompanionSheetViewController(viewModel: makeSpecificCompanionSheetViewModel())
    }

    func makeEmptyCompanionSheetViewController() -> EmptyCompanionSheetViewController {
        EmptyCompanionSheetViewController()
    }

    func makeCompanionDetailViewController(viewModel: CompanionDetailViewModel) -> CompanionDetailViewController {
        CompanionDetailViewController(viewModel: viewModel)
    }
    
    func makeDiningMapViewController() -> DiningMapViewController {
        DiningMapViewController(
            viewModel: makeDiningMapViewModel(),
            nearDiningSheetViewController: makeNearDiningSheetViewController(),
            saveDiningSheetViewController: makeSaveDiningSheetViewController()
        )
    }

    func makeNearDiningSheetViewController() -> NearDiningSheetViewController {
        NearDiningSheetViewController(viewModel: makeNearDiningBottomSheetViewModel())
    }

    func makeSaveDiningSheetViewController() -> SaveDiningSheetViewController {
        SaveDiningSheetViewController(viewModel: makeSaveDiningSheetViewModel())
    }
    
    func makeMatchingViewController(coordinator: MatchingCoordinator) -> UIViewController {
        let viewController = MatchingViewController(viewModel: makeMatchingViewModel())
        viewController.coordinator = coordinator
        return viewController
    }

    func makeMatchingScheduleDetailViewController(
        coordinator: MatchingCoordinator,
        item: MatchingMatchedCardItem
    ) -> UIViewController {
        let viewController = MatchingScheduleDetailViewController(item: item)
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeMatchingManageScheduleDetailViewController(
        coordinator: MatchingCoordinator,
        item: MatchingMatchedCardItem
    ) -> UIViewController {
        let viewController = MatchingManageDetailViewController(item: item)
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func makeMeetingViewController(coordinator: MeetingTabCoordinator) -> UIViewController {
        let viewController = MeetingTabViewController(viewModel: makeMeetingViewModel())
        viewController.coordinator = coordinator
        return viewController
    }

    func makeMeetingProgressViewController(coordinator: MeetingTabCoordinator, item: MeetingItem) -> UIViewController {
        let viewController = MeetingProgressViewController(viewModel: makeMeetingProgressViewModel(item: item))
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeMyPageViewController() -> MyPageViewController {
        MyPageViewController(viewModel: makeMyPageViewModel())
    }

    func makeAlarmViewController() -> AlarmViewController {
        AlarmViewController(viewModel: makeAlarmViewModel())
    }

    func makeSettingViewController() -> SettingViewController {
        SettingViewController(viewModel: makeSettingViewModel())
    }

    func makeWrittenPostViewController() -> WrittenPostViewController {
        WrittenPostViewController(viewModel: makeWrittenPostViewModel())
    }

    func makeRecruitCompanionViewController() -> UIViewController {
        makePlaceholderViewController(title: "동행글 작성")
    }

    func makeReviewViewController(
        coordinator: MeetingTabCoordinator,
        type: NearbyUserType,
        reviewItem: ReviewItem
    ) -> UIViewController {
        switch type {
        case .host:
            return makeHostReviewListViewController(
                coordinator: coordinator
            )

        case .participant:
            return makeReviewPostViewController(
                coordinator: coordinator,
                reviewItem: reviewItem,
                type: type,
                isLast: false,
                onSaved: nil
            )
        }
    }

    func makeHostReviewListViewController(coordinator: MeetingTabCoordinator) -> UIViewController {
        let viewController = HostReviewListViewController(viewModel: makeHostReviewListViewModel())

        viewController.coordinator = coordinator

        return viewController
    }

    func makeReviewPostViewController(
        coordinator: MeetingTabCoordinator,
        reviewItem: ReviewItem,
        type: NearbyUserType,
        isLast: Bool,
        onSaved: (() -> Void)?
    ) -> UIViewController {
        let viewController = ReviewPostViewController( viewModel: makeReviewPostViewModel(reviewItem: reviewItem, type: type, isLast: isLast))

        viewController.coordinator = coordinator

        viewController.onReviewSaved = onSaved

        return viewController
    }

    func makeReportPostViewController(coordinator: MeetingTabCoordinator) -> UIViewController {
        let viewController = ReportPostViewController(viewModel: makeReportPostViewModel())

        viewController.coordinator = coordinator

        return viewController
    }

    func makeReportCompletionViewController(
        coordinator: MeetingTabCoordinator) -> UIViewController {
        let viewController = ReportCompletionViewController(viewModel: EmptyViewModel())

        viewController.coordinator = coordinator

        return viewController
    }
    
    func makeCompanionRequestSentViewController(coordinator: NotificationCoordinator, hostName: String) -> UIViewController {
        let viewController = CompanionRequestSentViewController(
            viewModel: makeCompanionRequestSentViewModel(hostName: hostName)
        )
        viewController.coordinator = coordinator
        return viewController
    }

    func makeCompanionRequestDeclineViewController(coordinator: NotificationCoordinator) -> UIViewController {
        let viewController = CompanionRequestDeclineViewController(
            viewModel: makeCompanionRequestDeclineViewModel()
        )
        viewController.coordinator = coordinator
        return viewController
    }

    func makeHostRequestDeclineViewController(coordinator: NotificationCoordinator, applicantName: String) -> UIViewController {
        let viewController = HostRequestDeclineViewController(
            viewModel: makeHostRequestDeclineViewModel(applicantName: applicantName)
        )
        viewController.coordinator = coordinator
        return viewController
    }
}

// MARK: - Private Methods

private extension AppDIContainer {
    func makePlaceholderViewController(title: String) -> UIViewController {
        let viewController = UIViewController()

        viewController.title = title
        viewController.view.backgroundColor = .white

        return viewController
    }
}
