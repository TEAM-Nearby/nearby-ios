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
    
    func makeMyPageCoordinator(navigationController: UINavigationController) -> MyPageCoordinator {
        MyPageCoordinator(navigationController: navigationController, appDIContainer: self)
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

    func makeCompanionDetailViewModel(state: CompanionDetailState) -> CompanionDetailViewModel {
        CompanionDetailViewModel(state: state)
    }

    func makeNearCompanionSheetViewModel() -> NearCompanionBottomSheetViewModel {
        NearCompanionBottomSheetViewModel()
    }
    
    func makeSpecificCompanionSheetViewModel() -> SpecificCompanionBottomSheetViewModel {
        SpecificCompanionBottomSheetViewModel()
    }
    
    func makeMeetingViewModel() -> MeetingTabViewModel {
        MeetingTabViewModel()
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
    
    func makeHostReviewListViewModel() -> HostReviewListViewModel {
        HostReviewListViewModel()
    }
    
    func makeReportPostViewModel() -> ReportPostViewModel {
        ReportPostViewModel()
    }
    
    func makeReviewPostViewModel(reviewItem: ReviewItem) -> ReviewPostViewModel {
        ReviewPostViewModel(reviewItem: reviewItem)
    }
    
    func makeReportCompletionViewModel() -> ReportCompletionViewModel {
        ReportCompletionViewModel()
    }
    
    // MARK: - ViewControllers
    
    func makeLoginViewController() -> LoginViewController {
        return LoginViewController(viewModel: makeLoginViewModel())
    }
    
    func makeCompanionViewController(viewModel: CompanionViewModel) -> CompanionViewController {
        return CompanionViewController(viewModel: viewModel, nearbyBottomSheetViewController: makeNearCompanionSheetViewController(),
                                       specificBottomSheetViewController: makeSpecificCompanionSheetViewController(),
                                       emptyBottomSheetViewController: makeEmptyCompanionSheetViewController())
    }
    
    func makeNearCompanionSheetViewController() -> NearCompanionSheetViewController {
        return NearCompanionSheetViewController(viewModel: makeNearCompanionSheetViewModel())
    }
    
    func makeSpecificCompanionSheetViewController() -> SpecificCompanionSheetViewController {
        return SpecificCompanionSheetViewController(viewModel: makeSpecificCompanionSheetViewModel())
    }
    
    func makeEmptyCompanionSheetViewController() -> EmptyCompanionSheetViewController {
        return EmptyCompanionSheetViewController()
    }

    func makeCompanionDetailViewController(viewModel: CompanionDetailViewModel) -> CompanionDetailViewController {
        CompanionDetailViewController(viewModel: viewModel)
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
    
    func makeMeetingProgressViewController(coordinator: MeetingTabCoordinator, item: MeetingItem) -> UIViewController {
        let viewController = MeetingProgressViewController(
            viewModel: makeMeetingProgressViewModel(item: item)
        )
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func makeMyPageViewController() -> MyPageViewController {
        let viewModel = makeMyPageViewModel()
        return MyPageViewController(
            viewModel: viewModel
        )
    }

    func makeAlarmViewController() -> AlarmViewController {
        let viewModel = AlarmViewModel()
        return AlarmViewController(
            viewModel: viewModel
        )
    }

    func makeSettingViewController() -> SettingViewController {
        let viewModel = SettingViewModel()
        return SettingViewController(
            viewModel: viewModel
        )
    }
    
    func makeRecruitCompanionViewController() -> UIViewController {
        makePlaceholderViewController(title: "동행글 작성")
    }
    
    func makeHostReviewListViewController(coordinator: MeetingTabCoordinator) -> UIViewController {
        let viewController = HostReviewListViewController(viewModel: makeHostReviewListViewModel())
        viewController.coordinator = coordinator
        return viewController
    }
    
    func makeReviewPostViewController(coordinator: MeetingTabCoordinator, reviewItem: ReviewItem) -> UIViewController {
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
        let viewController = ReportCompletionViewController(viewModel: makeReportCompletionViewModel())
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
