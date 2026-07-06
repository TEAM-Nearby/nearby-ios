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

private extension MainTabCoordinator {
    func makeNavigationController(for item: NearbyTabItem) -> UINavigationController {
        let viewController = makeRootViewController(for: item)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(
            title: item.title,
            image: item.defaultImage,
            selectedImage: item.selectedImage
        )
        navigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        return navigationController
    }
    
    func makeRootViewController(for item: NearbyTabItem) -> UIViewController {
        switch item {
        case .companion:
            return diContainer.makeCompanionViewController()
        case .diningMap:
            return diContainer.makeDiningMapViewController()
        case .matching:
            return diContainer.makeMatchingViewController()
        case .meeting:
            return diContainer.makeMeetingViewController()
        case .myPage:
            return diContainer.makeMyPageViewController()
        }
    }
}
