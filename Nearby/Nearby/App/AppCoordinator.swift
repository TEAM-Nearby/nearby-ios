//
//  AppCoordinator.swift
//  Nearby
//
//  Created by soomin on 7/5/26.
//

import Combine
import UIKit

final class AppCoordinator {
    
    // MARK: - Properties
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    private let window: UIWindow
    private let diContainer: AppDIContainer
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(window: UIWindow, diContainer: AppDIContainer) {
        self.window = window
        self.diContainer = diContainer
        NotificationCenter.default.publisher(for: .authenticationExpired)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                
                childCoordinators.removeAll()
                showLogin()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Coordinator

extension AppCoordinator: Coordinator {
    
    func start() {
        showSplash()
    }
    
    func finish() {
        childCoordinators.removeAll()
    }
}

// MARK: - Methods

private extension AppCoordinator {
    
    func handleLaunchFlow() {
        showLogin()
    }
    
    func showSplash() {
        let splashViewController = diContainer.makeSplashViewController()
        
        splashViewController.onSplashCompleted = { [weak self] in
            self?.handleLaunchFlow()
        }
        
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
    }
    
    func showLogin() {
        childCoordinators.removeAll()
        
        let loginViewController = diContainer.makeLoginViewController()
        
        loginViewController.onLoginDidSucceed = { [weak self] onboardingStatus in
            
            guard let self else { return }
            
            switch onboardingStatus {
            case .started,
                 .phoneVerified:
                showPhoneVerification()
                
            case .completed:
                showMainTab()
            }
        }
        
        let navigationController = UINavigationController(
            rootViewController: loginViewController
        )
        
        navigationController.setNavigationBarHidden(true, animated: false)
        
        setRootViewController(navigationController, animated: true)
    }
    
    func showPhoneVerification() {
        guard let navigationController = window.rootViewController as? UINavigationController else {
            return
        }
        
        let viewController = diContainer.makePhoneVerificationViewController()
        
        viewController.onVerificationCompleted = { [weak self] in
            self?.showProfileSetting()
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showProfileSetting() {
        guard let navigationController = window.rootViewController as? UINavigationController else {
            return
        }
        
        let viewController = diContainer.makeCompanionProfileViewController()
        
        viewController.onProfileCompleted = { [weak self] in
            self?.showMainTab()
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showMainTab() {
        childCoordinators.removeAll()
        
        let mainTabCoordinator = diContainer.makeMainTabCoordinator()
        
        mainTabCoordinator.parentCoordinator = self
        
        mainTabCoordinator.onLogoutDidFinish = { [weak self, weak mainTabCoordinator] in
            
            guard let self else { return }
            
            if let mainTabCoordinator {
                removeChildCoordinator(mainTabCoordinator)
            }
            
            showLogin()
        }
        
        addChildCoordinator(mainTabCoordinator)
        
        mainTabCoordinator.start()
        
        setRootViewController(mainTabCoordinator.rootViewController, animated: true)
    }
    
    func setRootViewController(_ viewController: UIViewController, animated: Bool) {
        guard animated else {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            return
        }
        
        UIView.transition(
            with: window,
            duration: 0.3,
            options: [.transitionCrossDissolve, .allowAnimatedContent],
            animations: {
                self.window.rootViewController = viewController
            }
        )
        
        window.makeKeyAndVisible()
    }
}
