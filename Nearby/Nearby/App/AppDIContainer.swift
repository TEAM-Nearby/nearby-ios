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
        MeetingTabCoordinator(navigationController: navigationController, diContainer: self)
    }
    
    func makeCompanionCoordinator(navigationController: UINavigationController) -> CompanionCoordinator {
        CompanionCoordinator(navigationController: navigationController, diContainer: self)
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
    
    func makeMeetingViewModel() -> MeetingTabViewModel {
        MeetingTabViewModel()
    }
    
    func makeMeetingProgressViewModel(item: MeetingItem) -> MeetingProgressViewModel {
        MeetingProgressViewModel(item: item)
    }
    
    func makeHostReviewListViewModel() -> HostReviewListViewModel {
        HostReviewListViewModel()
    }
    
    func makeReportPostViewModel() -> ReportPostViewModel {
        ReportPostViewModel()
    }
    
    func makeReviewPostViewModel(reviewItem: ReviewItem) -> ReviewPostViewModel {
        ReviewPostViewModel(reviewItem: reviewItem)
    }
    
    // MARK: - ViewControllers
    
    func makeLoginViewController() -> LoginViewController {
        return LoginViewController(viewModel: makeLoginViewModel())
    }
    
    func makeCompanionViewController(viewModel: CompanionViewModel) -> CompanionViewController {
        return CompanionViewController(
            viewModel: viewModel,
            nearbyBottomSheetViewController: makeNearCompanionBottomSheetViewController(),
            specificBottomSheetViewController: makeSpecificCompanionBottomSheetViewController(),
            emptyBottomSheetViewController: makeEmptyCompanionBottomSheetViewController()
        )
    }
    
    func makeNearCompanionBottomSheetViewController() -> NearCompanionBottomSheetViewController {
        return NearCompanionBottomSheetViewController()
    }
    
    func makeSpecificCompanionBottomSheetViewController() -> SpecificCompanionSheetViewController {
        return SpecificCompanionSheetViewController()
    }
    
    func makeEmptyCompanionBottomSheetViewController() -> EmptyCompanionBottomSheetViewController {
        return EmptyCompanionBottomSheetViewController()
    }
    
    func makeDiningMapViewController() -> UIViewController {
        makePlaceholderViewController(title: "혼밥 지도")
    }
    
    func makeMatchingViewController() -> UIViewController {
        makePlaceholderViewController(title: "매칭")
    }
    
    func makeMeetingViewController(coordinator: MeetingTabCoordinator) -> UIViewController {
        let viewController = MeetingTabViewController(viewModel: makeMeetingViewModel())
        viewController.coordinator = coordinator
        return viewController
    }
    
    func makeMeetingProgressViewController(
        coordinator: MeetingTabCoordinator,
        item: MeetingItem
    ) -> UIViewController {
        let viewController = MeetingProgressViewController(
            viewModel: makeMeetingProgressViewModel(item: item)
        )
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func makeMyPageViewController() -> UIViewController {
        makePlaceholderViewController(title: "마이페이지")
    }
    
    func makeRecruitCompanionViewController() -> UIViewController {
        makePlaceholderViewController(title: "동행글 작성")
    }
    
    func makeReviewViewController(coordinator: MeetingTabCoordinator, type: NearbyUserType, reviewItem: ReviewItem) -> UIViewController {
        switch type {
        case .host:
            return makeHostReviewListViewController(coordinator: coordinator)
        case .participant:
            return makeReviewPostViewController(coordinator: coordinator, reviewItem: reviewItem)
        }
    }
    
    func makeHostReviewListViewController(coordinator: MeetingTabCoordinator) -> UIViewController {
        let viewController = HostReviewListViewController(
            viewModel: makeHostReviewListViewModel()
        )
        viewController.coordinator = coordinator
        return viewController
    }
    
    func makeReviewPostViewController(
        coordinator: MeetingTabCoordinator,
        reviewItem: ReviewItem
    ) -> UIViewController {
        let viewController = ReviewPostViewController(
            viewModel: makeReviewPostViewModel(reviewItem: reviewItem)
        )
        viewController.coordinator = coordinator
        return viewController
    }
    
    func makeReportPostViewController(coordinator: MeetingTabCoordinator) -> UIViewController {
        let viewController = ReportPostViewController(viewModel: makeReportPostViewModel())
        viewController.coordinator = coordinator
        return viewController
    }
    
    func makeReportCompletionViewController(coordinator: MeetingTabCoordinator) -> UIViewController {
        let viewController = ReportCompletionViewController(viewModel: EmptyViewModel())
        viewController.coordinator = coordinator
        return viewController
    }
}

private extension AppDIContainer {
    func makePlaceholderViewController(title: String) -> UIViewController {
        let viewController = UIViewController()
        viewController.title = title
        viewController.view.backgroundColor = .white
        return viewController
    }
}
