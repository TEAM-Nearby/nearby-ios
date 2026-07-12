//
//  MainTabCoordinator.swift
//  Nearby
//
//  Created by soomin on 7/5/26.
//

import UIKit

final class MainTabCoordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    let rootViewController = MainTabBarController()
    private let diContainer: AppDIContainer
    var onLogoutDidFinish: (() -> Void)?
    
    init(diContainer: AppDIContainer) {
        self.diContainer = diContainer
    }
}

// MARK: - Coordinator

extension MainTabCoordinator: Coordinator {
     func start() {
         rootViewController.viewControllers = NearbyTabItem.allCases.map {
             makeNavigationController(for: $0)
         }
     }
     
     func finish() {
         parentCoordinator?.removeChildCoordinator(self)
     }
 }

extension MainTabCoordinator {
    func switchTab(to item: NearbyTabItem) {
        guard let index = NearbyTabItem.allCases.firstIndex(of: item) else { return }
        rootViewController.selectedIndex = index
    }
}

private extension MainTabCoordinator {
    func makeNavigationController(for item: NearbyTabItem) -> UINavigationController {
        let navigationController = UINavigationController()
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
                navigationController: navigationController
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
}
