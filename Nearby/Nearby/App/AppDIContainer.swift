//
//  AppDIContainer.swift
//  Nearby
//
//  Created by soomin on 7/5/26.
//

import UIKit

final class AppDIContainer {
    
    // MARK: - Properties

    private lazy var tokenStorage: TokenStorage = KeychainTokenStorage()
    private lazy var networkProvider = NetworkProvider(tokenStorage: tokenStorage)
    private lazy var meetingEventCenter = MeetingEventCenter()

    private lazy var authService: AuthService = DefaultAuthService(networkProvider: networkProvider)
    private lazy var authRepository: AuthRepository = DefaultAuthRepository(oauthProvider: DefaultKakaoOAuthProvider(), authService: authService, tokenStorage: tokenStorage)
    private lazy var myPageService: MyPageService = DefaultMyPageService(networkProvider: networkProvider)
    private lazy var myPageRepository: MyPageRepository = DefaultMyPageRepository(service: myPageService)
    private lazy var matchingService: MatchedCompanionListService = DefaultMatchedCompanionListService(networkProvider: networkProvider)
    private lazy var matchingRepository: MatchedCompanionListRepository = DefaultMatchedCompanionListRepository(service: matchingService)

    lazy var auth = AuthDIContainer(authRepository: authRepository)
    lazy var companion = CompanionDIContainer(networkProvider: networkProvider, myPageRepository: myPageRepository)
    lazy var companionDetail = CompanionDetailDIContainer(tokenStorage: tokenStorage, networkProvider: networkProvider)
    lazy var diningMap = DiningMapDIContainer(networkProvider: networkProvider, myPageRepository: myPageRepository)
    lazy var matching = MatchingDIContainer(repository: matchingRepository, eventCenter: meetingEventCenter)
    lazy var myPage = MyPageDIContainer(networkProvider: networkProvider, authRepository: authRepository, myPageRepository: myPageRepository)
    lazy var meeting = MeetingDIContainer(networkProvider: networkProvider, eventCenter: meetingEventCenter, matchingRepository: matchingRepository, myPageRepository: myPageRepository)
    lazy var notification = NotificationDIContainer(networkProvider: networkProvider)
    lazy var recruitCompanion = RecruitCompanionDIContainer(networkProvider: networkProvider)

    var hasStoredSession: Bool {
        guard let accessToken = tokenStorage.accessToken,
              let refreshToken = tokenStorage.refreshToken else {
            return false
        }
        return !accessToken.isEmpty && !refreshToken.isEmpty
    }

    // MARK: - Factory Methods

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

    func makeSplashViewController() -> SplashViewController {
        SplashViewController()
    }
}
