//
//  AppCoordinator.swift
//  Nearby
//
//  Created by soomin on 7/5/26.
//

import UIKit

final class AppCoordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    private let window: UIWindow
    private let diContainer: AppDIContainer
    
    init(window: UIWindow, diContainer: AppDIContainer) {
        self.window = window
        self.diContainer = diContainer
    }
}

// MARK: - Coordinator

extension AppCoordinator: Coordinator {
     func start() {
         showMainTab()
     }
     
     func finish() {
         childCoordinators.removeAll()
     }
    
    // MARK: - Method
    
    func showMainTab() {
        let mainTabCoordinator = diContainer.makeMainTabCoordinator()
        mainTabCoordinator.parentCoordinator = self
        addChildCoordinator(mainTabCoordinator)
        mainTabCoordinator.start()
        
        window.rootViewController = mainTabCoordinator.rootViewController
        window.makeKeyAndVisible()
    }
    
    func showLogin() {
        let loginViewController = diContainer.makeLoginViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func showHostProfileTest() {
        let hostProfileViewController =
        diContainer.makeHostProfileViewController()
        
        let navigationController = UINavigationController(
            rootViewController: hostProfileViewController
        )
        
        navigationController.setNavigationBarHidden(true, animated: false)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
 }
