//
//  AppDIContainer.swift
//  Nearby
//
//  Created by soomin on 7/5/26.
//

import UIKit

final class AppDIContainer {
    private lazy var tokenStorage: TokenStorage = KeychainTokenStorage()
    private lazy var networkProvider = NetworkProvider(tokenStorage: tokenStorage)

    var hasStoredSession: Bool {
        guard let accessToken = tokenStorage.accessToken, let refreshToken = tokenStorage.refreshToken else {
            return false
        }

        return !accessToken.isEmpty && !refreshToken.isEmpty
    }
    
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
    
    func makeDiningMapCoordinator(navigationController: UINavigationController) -> DiningMapCoordinator {
        DiningMapCoordinator(navigationController: navigationController, diContainer: self)
    }
    
    func makeMatchingCoordinator(navigationController: UINavigationController) -> MatchingCoordinator {
        MatchingCoordinator(navigationController: navigationController, diContainer: self)
    }
    
    func makeMyPageCoordinator(navigationController: UINavigationController) -> MyPageCoordinator {
        MyPageCoordinator(navigationController: navigationController, appDIContainer: self)
    }
    
    func makeNotificationCoordinator(navigationController: UINavigationController) -> NotificationCoordinator {
        NotificationCoordinator(navigationController: navigationController, diContainer: self)
    }
    
    // MARK: - Networks
    
    private func makeKakaoOAuthProvider() -> KakaoOAuthProvider {
        DefaultKakaoOAuthProvider()
    }
    
    private func makeAuthService() -> AuthService {
        DefaultAuthService(networkProvider: networkProvider)
    }
    
    private func makeCompanionService() -> CompanionService {
        DefaultCompanionService(networkProvider: networkProvider)
    }

    private func makeGooglePlaceService() -> GooglePlaceService {
        GooglePlaceService()
    }

    private func makeRecruitCompanionService() -> RecruitCompanionService {
        DefaultRecruitCompanionService(networkProvider: networkProvider)
    }

    private func makeCompanionDetailService() -> CompanionDetailService {
        DefaultCompanionDetailService(networkProvider: networkProvider)
    }

    private func makeProfileService() -> ProfileService {
        DefaultProfileService(networkProvider: networkProvider)
    }

    private func makeMatchedCompanionListService() -> MatchedCompanionListService {
        DefaultMatchedCompanionListService(networkProvider: networkProvider)
    }
    
    private func makeMeetingService() -> MeetingService {
        DefaultMeetingService(networkProvider: networkProvider)
    }
    
    private func makeHostCompanionService() -> HostCompanionService {
        DefaultHostCompanionService(networkProvider: networkProvider)
    }
    
    private func makeApplicantCompanionService() -> ApplicantCompanionService {
        DefaultApplicantCompanionService(networkProvider: networkProvider)
    }
    
    private func makeMyPageService() -> MyPageService {
        DefaultMyPageService(networkProvider: networkProvider)
    }
    
    // MARK: - Repositories
    
    private func makeAuthRepository() -> AuthRepository {
        DefaultAuthRepository(oauthProvider: makeKakaoOAuthProvider(), authService: makeAuthService(), tokenStorage: tokenStorage)
    }
    
    private func makeCompanionRepository() -> CompanionRepository {
        DefaultCompanionRepository(service: makeCompanionService())
    }

    private func makeRecruitCompanionRepository() -> RecruitCompanionRepository {
        DefaultRecruitCompanionRepository(
            googlePlaceService: makeGooglePlaceService(),
            recruitCompanionService: makeRecruitCompanionService()
        )
    }
    
    private func makeMeetingRepository() -> MeetingRepository {
        DefaultMeetingRepository(meetingService: makeMeetingService())
    }
    
    func makeHostCompanionRepository() -> HostCompanionRepository {
        DefaultHostCompanionRepository(hostCompanionService: makeHostCompanionService())
    }
    
    func makeApplicantCompanionRepository() -> ApplicantCompanionRepository {
        DefaultApplicantCompanionRepository(applicantCompanionService: makeApplicantCompanionService())
    }
    
    private func makeCompanionDetailRepository() -> CompanionDetailRepository {
        DefaultCompanionDetailRepository(service: makeCompanionDetailService())
    }

    private func makeProfileRepository() -> ProfileRepository {
        DefaultProfileRepository(service: makeProfileService())
    }

    private func makeMatchedCompanionListRepository() -> MatchedCompanionListRepository {
        DefaultMatchedCompanionListRepository(service: makeMatchedCompanionListService())
    }
    
    private func makeMyPageRepository() -> MyPageRepository {
        DefaultMyPageRepository(service: makeMyPageService())
    }
    
    // MARK: - ViewModels
    
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(authRepository: makeAuthRepository())
    }
    
    func makeCompanionViewModel() -> CompanionViewModel {
        CompanionViewModel()
    }
    
    func makeCompanionProfileViewModel() -> CompanionProfileViewModel {
        CompanionProfileViewModel(authRepository: makeAuthRepository())
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
    
    func makeDiningInfoSheetViewModel() -> DiningInfoSheetViewModel {
        DiningInfoSheetViewModel()
    }
    
    func makeCompanionDetailViewModel(state: CompanionDetailState) -> CompanionDetailViewModel {
        CompanionDetailViewModel(state: state, repository: makeCompanionDetailRepository(), currentUserId: tokenStorage.currentUserId)
    }
    
    func makeNearCompanionSheetViewModel() -> NearCompanionSheetViewModel {
        NearCompanionSheetViewModel(repository: makeCompanionRepository())
    }
    
    func makeSpecificCompanionSheetViewModel() -> SpecificCompanionSheetViewModel {
        SpecificCompanionSheetViewModel()
    }
    
    func makeMeetingViewModel() -> MeetingTabViewModel {
        MeetingTabViewModel(repository: makeMeetingRepository())
    }
    
    func makeMeetingProgressViewModel(meetingId: Int) -> MeetingProgressViewModel {
        MeetingProgressViewModel(
            meetingId: meetingId,
            repository: makeMeetingRepository()
        )
    }
    
    func makeMatchingViewModel() -> MatchingViewModel {
        MatchingViewModel(repository: makeMatchedCompanionListRepository())
    }
    
    func makeRecruitCompanionViewModel() -> RecruitCompanionViewModel {
        RecruitCompanionViewModel(
            repository: makeRecruitCompanionRepository(),
            searchCoordinate: (latitude: 41.389458, longitude: 2.168289)
        )
    }

    func makeMeetingProgressViewModel(meetingId: Int, repository: MeetingRepository) -> MeetingProgressViewModel {
        MeetingProgressViewModel(meetingId: meetingId, repository: makeMeetingRepository())
    }
    
    func makeMyPageViewModel() -> MyPageViewModel {
        MyPageViewModel(repository: makeMyPageRepository())
    }
    
    func makeAlarmViewModel(initialTab: AlarmTab = .sent) -> AlarmViewModel {
        AlarmViewModel(initialTab: initialTab)
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
    
    func makeCompanionRequestAcceptViewModel(applicationId: Int) -> CompanionRequestAcceptViewModel {
        CompanionRequestAcceptViewModel(
            applicationId: applicationId,
            repository: makeApplicantCompanionRepository()
        )
    }
    
    func makeHostRequestRecieveViewModel(applicationId: Int) -> HostRequestRecieveViewModel {
        HostRequestRecieveViewModel(
            applicationId: applicationId,
            repository: makeHostCompanionRepository()
        )
    }
    
    func makeHostRequestDeclineViewModel(applicantName: String, applicationId: Int) -> HostRequestDeclineViewModel {
        HostRequestDeclineViewModel(
            applicantName: applicantName,
            applicationId: applicationId,
            repository: makeHostCompanionRepository()
        )
    }
    
    func makeHostRequestAllowViewModel(applicantName: String, applicantProfileImageUrl: String?, locationName: String, meetingAt: String, matchId: Int?, postType: PostType) -> HostRequestAllowViewModel {
        HostRequestAllowViewModel(applicantProfileImageUrl: applicantProfileImageUrl, applicantName: applicantName, locationName: locationName, meetingAt: meetingAt, matchId: matchId, postType: postType
        )
    }
    
    func makeHostProfileViewModel(profileId: Int) -> HostProfileViewModel {
        HostProfileViewModel(profileId: profileId, repository: makeProfileRepository())
    }
  
    func makePhoneVerificationViewModel() -> PhoneVerificationViewModel {
        let repository = makeAuthRepository()
        return PhoneVerificationViewModel(authRepository: repository)
    }
    
    // MARK: - ViewControllers
    
    func makeSplashViewController() -> SplashViewController {
        SplashViewController()
    }
    
    func makeHostProfileViewController(profileId: Int) -> HostProfileViewController {
        let viewModel = makeHostProfileViewModel(profileId: profileId)
        return HostProfileViewController(viewModel: viewModel)
    }
    
    func makeLoginViewController() -> LoginViewController {
        LoginViewController(viewModel: makeLoginViewModel())
    }
    
    func makeCompanionProfileViewController() -> CompanionProfileViewController {
        CompanionProfileViewController(viewModel: makeCompanionProfileViewModel())
    }

    func makeCompanionViewController(viewModel: CompanionViewModel) -> CompanionViewController {
        CompanionViewController(viewModel: viewModel,
                                nearbySheetViewController: makeNearCompanionSheetViewController(),
                                specificSheetViewController: makeSpecificCompanionSheetViewController(),
                                emptySheetViewController: makeEmptyCompanionSheetViewController())
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
            saveDiningSheetViewController: makeSaveDiningSheetViewController(),
            diningInfoSheetViewController: makeDiningInfoSheetViewController()
        )
    }
    
    func makeNearDiningSheetViewController() -> NearDiningSheetViewController {
        NearDiningSheetViewController(viewModel: makeNearDiningBottomSheetViewModel())
    }
    
    func makeSaveDiningSheetViewController() -> SaveDiningSheetViewController {
        SaveDiningSheetViewController(viewModel: makeSaveDiningSheetViewModel())
    }
    
    func makeDiningInfoSheetViewController() -> DiningInfoSheetViewController {
        DiningInfoSheetViewController(viewModel: makeDiningInfoSheetViewModel())
    }
    
    func makeMatchingViewController(coordinator: MatchingCoordinator) -> UIViewController {
        let viewController = MatchingViewController(viewModel: makeMatchingViewModel())
        viewController.coordinator = coordinator
        return viewController
    }
    
    func makeMatchingScheduleDetailViewModel(matchId: Int) -> MatchingScheduleDetailViewModel {
        MatchingScheduleDetailViewModel(
            matchId: matchId,
            repository: makeMatchedCompanionListRepository()
        )
    }

    func makeMatchingScheduleDetailViewController(coordinator: MatchingCoordinator, matchId: Int) -> UIViewController {
        let viewController = MatchingScheduleDetailViewController(
            viewModel: makeMatchingScheduleDetailViewModel(matchId: matchId)
        )
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func makeMatchingManageScheduleDetailViewController(coordinator: MatchingCoordinator, item: MatchingMatchedCardItem) -> UIViewController {
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
    
    func makeMeetingProgressViewController(coordinator: MeetingTabCoordinator, meetingId: Int) -> UIViewController {
        let viewController = MeetingProgressViewController(
            viewModel: makeMeetingProgressViewModel(meetingId: meetingId)
        )
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func makeMyPageViewController() -> MyPageViewController {
        MyPageViewController(viewModel: makeMyPageViewModel())
    }
    
    func makeAlarmViewController(initialTab: AlarmTab = .sent) -> AlarmViewController {
        AlarmViewController(viewModel: makeAlarmViewModel(initialTab: initialTab))
    }
    
    func makeSettingViewController() -> SettingViewController {
        SettingViewController(viewModel: makeSettingViewModel())
    }
    
    func makeWrittenPostViewController() -> WrittenPostViewController {
        WrittenPostViewController(viewModel: makeWrittenPostViewModel())
    }
    
    func makeRecruitCompanionViewController(coordinator: CompanionCoordinator? = nil) -> UIViewController {
        let viewController = RecruitCompanionViewController(viewModel: makeRecruitCompanionViewModel())
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func makeReviewViewController(coordinator: MeetingTabCoordinator, type: NearbyUserType, reviewItem: ReviewItem) -> UIViewController {
        switch type {
        case .host:
            return makeHostReviewListViewController(coordinator: coordinator)

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
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func makeReviewPostViewController(coordinator: MeetingTabCoordinator, reviewItem: ReviewItem, type: NearbyUserType, isLast: Bool, onSaved: (() -> Void)?) -> UIViewController {
        let viewController = ReviewPostViewController(
            viewModel: makeReviewPostViewModel(reviewItem: reviewItem, type: type, isLast: isLast)
        )
        viewController.coordinator = coordinator
        viewController.onReviewSaved = onSaved
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func makeReportPostViewController(coordinator: MeetingTabCoordinator) -> UIViewController {
        let viewController = ReportPostViewController(viewModel: makeReportPostViewModel())
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
    
    func makeCompanionRequestSentViewController(coordinator: NotificationCoordinator, hostName: String) -> UIViewController {
        let viewController = CompanionRequestSentViewController(
            viewModel: makeCompanionRequestSentViewModel(hostName: hostName)
        )
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func makeCompanionRequestDeclineViewController(coordinator: NotificationCoordinator) -> UIViewController {
        let viewController = CompanionRequestDeclineViewController(viewModel: makeCompanionRequestDeclineViewModel())
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func makeCompanionRequestAcceptViewController(coordinator: NotificationCoordinator, applicationId: Int) -> UIViewController {
        let viewController = CompanionRequestAcceptViewController(
            viewModel: makeCompanionRequestAcceptViewModel(applicationId: applicationId)
        )
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func makeHostRequestRecieveViewController(coordinator: NotificationCoordinator, applicationId: Int) -> HostRequestRecieveViewController {
        let viewController = HostRequestRecieveViewController(
            viewModel: makeHostRequestRecieveViewModel(applicationId: applicationId)
        )
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func makeHostRequestDeclineViewController(coordinator: NotificationCoordinator, applicantName: String, applicationId: Int) -> UIViewController {
        let viewController = HostRequestDeclineViewController(
            viewModel: makeHostRequestDeclineViewModel(applicantName: applicantName, applicationId: applicationId)
        )
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func makeHostRequestAllowViewController(coordinator: NotificationCoordinator, applicantName: String, applicantProfileImageUrl: String?, locationName: String, meetingAt: String, matchId: Int?, postType: PostType) -> UIViewController {
        let viewController = HostRequestAllowViewController(
            viewModel: makeHostRequestAllowViewModel(
                applicantName: applicantName,
                applicantProfileImageUrl: applicantProfileImageUrl,
                locationName: locationName,
                meetingAt: meetingAt,
                matchId: matchId,
                postType: postType
            )
        )
        viewController.coordinator = coordinator
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    func makePhoneVerificationViewController() -> PhoneVerificationViewController {

        let repository = makeAuthRepository()
        let viewModel = PhoneVerificationViewModel(authRepository: repository)

        return PhoneVerificationViewController(viewModel: viewModel)
    }
}
