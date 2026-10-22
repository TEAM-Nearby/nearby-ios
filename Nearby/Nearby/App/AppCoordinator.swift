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
    private let appIntroductionStorage: AppIntroductionStorage
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(
        window: UIWindow,
        diContainer: AppDIContainer,
        appIntroductionStorage: AppIntroductionStorage
    ) {
        self.window = window
        self.diContainer = diContainer
        self.appIntroductionStorage = appIntroductionStorage

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
        guard appIntroductionStorage.hasCompletedAppIntroduction else {
            showAppIntroduction()
            return
        }

        handleAuthenticationFlow()
    }

    func handleAuthenticationFlow() {
        guard diContainer.hasStoredSession else {
            showLogin()
            return
        }

        guard let onboardingStatus = diContainer.storedOnboardingStatus else {
            showLogin()
            return
        }

        switch onboardingStatus {
        case .started, .phoneVerified:
            showLogin()
            showAgreement()

        case .completed:
            showMainTab()
        }
    }
    
    func showSplash() {
        let splashViewController = diContainer.makeSplashViewController()
        
        splashViewController.onSplashCompleted = { [weak self] in
            self?.handleLaunchFlow()
        }
        
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
    }

    func showAppIntroduction() {
        childCoordinators.removeAll()

        let viewController = diContainer.makeAppIntroductionViewController()

        viewController.onAppIntroductionCompleted = { [weak self] in
            guard let self else { return }

            appIntroductionStorage.markAppIntroductionAsCompleted()
            showLogin()
        }

        setRootViewController(viewController, animated: true)
    }
    
    func showLogin() {
        childCoordinators.removeAll()
        diContainer.pushNotificationManager.onRoute = nil
        
        let loginViewController = diContainer.auth.makeLoginViewController()

        loginViewController.onLoginDidSucceed = { [weak self] onboardingStatus in guard let self else { return }
            
            switch onboardingStatus {
            case .started, .phoneVerified:
                showAgreement()
                
            case .completed:
                showMainTab()
            }
        }
        
        let navigationController = NearbyNavigationController(
            rootViewController: loginViewController
        )
        
        navigationController.setNavigationBarHidden(true, animated: false)
        setRootViewController(navigationController, animated: true)
    }
    
    func showAgreement() {
        guard let navigationController = window.rootViewController as? UINavigationController else {
            return
        }

        let viewController = diContainer.auth.makeAgreementViewController()

        viewController.onAgreementDetailRequested = { [weak self] type in
            self?.showAgreementDetail(type: type)
        }
        
        viewController.onBackButtonDidTap = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }

        viewController.onAgreementCompleted = { [weak self] in
            self?.showPhoneVerification()
        }

        navigationController.pushViewController(viewController, animated: true)
    }

    func showAgreementDetail(type: AgreementDetailType) {
        guard let navigationController = window.rootViewController as? UINavigationController else {
            return
        }

        let viewController = diContainer.auth.makeAgreementDetailViewController(type: type)
        
        viewController.onBackButtonDidTap = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }

        navigationController.pushViewController(viewController, animated: true)
    }

    func showPhoneVerification() {
        guard let navigationController = window.rootViewController as? UINavigationController else {
            return
        }
        
        let viewController = diContainer.auth.makePhoneVerificationViewController()

        viewController.onBackButtonDidTap = { [weak self] in
            guard let navigationController = self?.window.rootViewController as? UINavigationController else { return }
            navigationController.popViewController(animated: true)
        }
        
        viewController.onBackButtonDidTap = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        
        viewController.onVerificationCompleted = { [weak self] in
            self?.showProfileSetting()
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showProfileSetting() {
        guard let navigationController = window.rootViewController as? UINavigationController else {
            return
        }
        
        let viewController = diContainer.auth.makeCompanionProfileViewController()

        viewController.onBackButtonDidTap = { [weak self] in
            guard let navigationController = self?.window.rootViewController as? UINavigationController else { return }
            navigationController.popViewController(animated: true)
        }
        
        viewController.onBackButtonDidTap = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }
        
        viewController.onProfileCompleted = { [weak self] in
            self?.showEmergencyContact()
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showEmergencyContact() {
        guard let navigationController = window.rootViewController as? UINavigationController else {
            return
        }

        let viewController = diContainer.auth.makeEmergencyContactViewController()

        viewController.onBackButtonDidTap = { [weak navigationController] in
            navigationController?.popViewController(animated: true)
        }

        viewController.onRegistrationCompleted = { [weak self] in
            guard let self else { return }

            diContainer.saveOnboardingStatus(.completed)
            showMainTab()
        }

        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showMainTab() {
        childCoordinators.removeAll()
        diContainer.pushNotificationManager.start()
        
        let mainTabCoordinator = diContainer.makeMainTabCoordinator()
        
        mainTabCoordinator.parentCoordinator = self
        mainTabCoordinator.onLogoutDidFinish = { [weak self, weak mainTabCoordinator] in guard let self else { return }
            
            if let mainTabCoordinator {
                removeChildCoordinator(mainTabCoordinator)
            }
            
            showLogin()
        }
        
        addChildCoordinator(mainTabCoordinator)
        mainTabCoordinator.start()
        setRootViewController(mainTabCoordinator.rootViewController, animated: true)
        diContainer.pushNotificationManager.onRoute = { [weak mainTabCoordinator] route in
            mainTabCoordinator?.showNotification(for: route)
        }
    }
    
    func setRootViewController(_ viewController: UIViewController, animated: Bool) {
        guard animated else {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            return
        }
        
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve, .allowAnimatedContent],
                          animations: { self.window.rootViewController = viewController })
        
        window.makeKeyAndVisible()
    }
}
