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
            
        case .meeting:
            let meetingCoordinator = diContainer.makeMeetingCoordinator(
                navigationController: navigationController
            )
            meetingCoordinator.parentCoordinator = self
            addChildCoordinator(meetingCoordinator)
            meetingCoordinator.start()
            
        case .myPage:
            configureMyPageCoordinator(
                navigationController: navigationController
            )
            
        default:
            let viewController = makeRootViewController(for: item)
            navigationController.setViewControllers([viewController], animated: false)
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

    func configureMyPageCoordinator(navigationController: UINavigationController) {
        let myPageCoordinator =
            diContainer.makeMyPageCoordinator(
                navigationController: navigationController
            )

        myPageCoordinator.parentCoordinator = self
        addChildCoordinator(myPageCoordinator)
        myPageCoordinator.start()
    }

    func makeRootViewController(for item: NearbyTabItem) -> UIViewController {
        switch item {
        case .companion:
            preconditionFailure("Companion tab should be configured by CompanionCoordinator")
        case .diningMap:
            return diContainer.makeDiningMapViewController()
        case .matching:
            return diContainer.makeMatchingViewController()
        case .meeting:
            preconditionFailure("Meeting tab should be configured by MeetingCoordinator")
        case .myPage:
            preconditionFailure("MyPage tab should be configured by MyPageCoordinator")
        }
    }
}
