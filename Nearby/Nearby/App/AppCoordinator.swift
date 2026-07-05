//
//  AppCoordinator.swift
//  Nearby
//
//  Created by soomin on 7/5/26.
//

import UIKit

final class AppCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    private let window: UIWindow
    private let diContainer: AppDIContainer
    
    init(window: UIWindow, diContainer: AppDIContainer) {
        self.window = window
        self.diContainer = diContainer
    }
    
    func start() {
        showMainTab()
    }
    
    func finish() {
        childCoordinators.removeAll()
    }
}

private extension AppCoordinator {
    func showMainTab() {
        let mainTabCoordinator = diContainer.makeMainTabCoordinator()
        mainTabCoordinator.parentCoordinator = self
        addChildCoordinator(mainTabCoordinator)
        mainTabCoordinator.start()
        
        window.rootViewController = mainTabCoordinator.rootViewController
        window.makeKeyAndVisible()
    }
}
