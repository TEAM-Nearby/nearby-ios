//
//  MainTabCoordinator.swift
//  Nearby
//
//  Created by soomin on 7/5/26.
//

import UIKit

final class MainTabCoordinator {
    
    // MARK: - Properties
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    let rootViewController = MainTabBarController()
    let isGuest: Bool
    var onLoginRequested: (() -> Void)?
    private let diContainer: AppDIContainer
    var onLogoutDidFinish: (() -> Void)?
    
    // MARK: - Initializer
    
    init(diContainer: AppDIContainer, isGuest: Bool = false) {
        self.isGuest = isGuest
        self.diContainer = diContainer
    }
    
    func presentGuestAgreementIfNeeded() {
        guard rootViewController.requiresGuestAgreement else { return }
        let agreement = GuestAgreementViewController()
        agreement.onAgree = { [weak self] in
            guard let self else { return }
            rootViewController.requiresGuestAgreement = false
            let navigationController = rootViewController.viewControllers?.first as? UINavigationController
            (navigationController?.viewControllers.first as? CompanionViewController)?.completeGuestAgreement()
        }
        rootViewController.present(agreement, animated: false)
    }
    
    func makeNavigationController(for item: NearbyTabItem) -> UINavigationController {
        let navigationController = NearbyNavigationController()
        navigationController.view.backgroundColor = .clear
        navigationController.edgesForExtendedLayout = [.bottom]
        navigationController.extendedLayoutIncludesOpaqueBars = true
        configureRootViewController(for: item, navigationController: navigationController)
        navigationController.tabBarItem = UITabBarItem(
            title: item.title,
            image: item.defaultImage,
            selectedImage: item.selectedImage
        )
        navigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        return navigationController
    }
    
    func configureRootViewController(for item: NearbyTabItem, navigationController: UINavigationController) {
        switch item {
        case .companion:
            let companionCoordinator = diContainer.makeCompanionCoordinator(
                navigationController: navigationController
            )
            companionCoordinator.parentCoordinator = self
            addChildCoordinator(companionCoordinator)
            companionCoordinator.start()
            
        case .diningMap:
            let diningMapCoordinator = diContainer.makeDiningMapCoordinator(
                navigationController: navigationController
            )
            diningMapCoordinator.parentCoordinator = self
            addChildCoordinator(diningMapCoordinator)
            diningMapCoordinator.start()
            
        case .meeting:
            let meetingCoordinator = diContainer.makeMeetingCoordinator(
                navigationController: navigationController
            )
            meetingCoordinator.parentCoordinator = self
            addChildCoordinator(meetingCoordinator)
            meetingCoordinator.start()
            
        case .matching:
            configureMatchingCoordinator(
                navigationController: navigationController
            )
            
        case .myPage:
            configureMyPageCoordinator(
                navigationController: navigationController
            )
        }
    }
    
    func configureCompanionCoordinator(navigationController: UINavigationController) {
        let companionCoordinator =
        diContainer.makeCompanionCoordinator(
            navigationController: navigationController
        )
        
        companionCoordinator.parentCoordinator = self
        addChildCoordinator(companionCoordinator)
        companionCoordinator.start()
    }
    
    func configureMeetingCoordinator(navigationController: UINavigationController) {
        let meetingCoordinator =
        diContainer.makeMeetingCoordinator(
            navigationController: navigationController
        )
        
        meetingCoordinator.parentCoordinator = self
        addChildCoordinator(meetingCoordinator)
        meetingCoordinator.start()
    }
    
    func configureMatchingCoordinator(navigationController: UINavigationController) {
        let matchingCoordinator =
        diContainer.makeMatchingCoordinator(
            navigationController: navigationController
        )
        
        matchingCoordinator.parentCoordinator = self
        addChildCoordinator(matchingCoordinator)
        matchingCoordinator.start()
    }
    
    func configureMyPageCoordinator(navigationController: UINavigationController) {
        let myPageCoordinator =
        diContainer.makeMyPageCoordinator(
            navigationController: navigationController, isGuest: isGuest
        )
        
        myPageCoordinator.parentCoordinator = self
        
        myPageCoordinator.onLogoutDidFinish = { [weak self] in
            self?.onLogoutDidFinish?()
        }
        
        myPageCoordinator.onFindCompanionDidTap = { [weak self] in
            self?.switchTab(to: .companion)
        }
        
        addChildCoordinator(myPageCoordinator)
        myPageCoordinator.start()
    }
    
    func makeRootViewController(for item: NearbyTabItem) -> UIViewController {
        switch item {
        case .companion:
            preconditionFailure("Companion tab should be configured by CompanionCoordinator")
        case .diningMap:
            preconditionFailure("Dining map tab should be configured by DiningMapCoordinator")
        case .matching:
            preconditionFailure("Matching tab should be configured by MatchingCoordinator")
        case .meeting:
            preconditionFailure("Meeting tab should be configured by MeetingCoordinator")
        case .myPage:
            preconditionFailure("MyPage tab should be configured by MyPageCoordinator")
        }
    }
    
    func showNotification(for route: PushNotificationRoute) {
        guard !requireLoginIfGuest(isGeneralFeature: true) else { return }
        switchTab(to: .meeting)
        let meetingCoordinator = childCoordinators.first { $0 is MeetingTabCoordinator } as? MeetingTabCoordinator
        meetingCoordinator?.showNotification(for: route)
    }
    
    @discardableResult
    func requireLoginIfGuest(isGeneralFeature: Bool = false) -> Bool {
        guard isGuest else { return false }
        guard rootViewController.presentedViewController == nil else { return true }
        let guide = GuestLoginGuideViewController(isGeneralFeature: isGeneralFeature)
        guide.onLogin = { [weak self] in self?.onLoginRequested?() }
        rootViewController.present(guide, animated: true)
        return true
    }
    
    func switchTab(to item: NearbyTabItem) {
        guard let index = NearbyTabItem.allCases.firstIndex(of: item) else { return }
        rootViewController.selectedIndex = index
    }
}

// MARK: - Coordinator

extension MainTabCoordinator: Coordinator {
    func start() {
        rootViewController.requiresGuestAgreement = isGuest
        rootViewController.onFirstAppearance = { [weak self] in
            self?.presentGuestAgreementIfNeeded()
        }
        rootViewController.viewControllers = NearbyTabItem.allCases.map {
            makeNavigationController(for: $0)
        }
    }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}
