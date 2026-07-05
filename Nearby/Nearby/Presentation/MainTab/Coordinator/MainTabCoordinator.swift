//
//  MainTabCoordinator.swift
//  Nearby
//
//  Created by soomin on 7/5/26.
//

import UIKit

final class MainTabCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    let rootViewController = UITabBarController()
    private let diContainer: AppDIContainer
    
    init(diContainer: AppDIContainer) {
        self.diContainer = diContainer
    }
    
    func start() {
        rootViewController.viewControllers = TabItem.allCases.map {
            makeNavigationController(for: $0)
        }
    }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}

private extension MainTabCoordinator {
    enum TabItem: CaseIterable {
        case companion
        case diningMap
        case matching
        case meeting
        case myPage
        
        var title: String {
            switch self {
            case .companion:
                return "동행 찾기"
            case .diningMap:
                return "혼밥 지도"
            case .matching:
                return "매칭"
            case .meeting:
                return "만남"
            case .myPage:
                return "마이페이지"
            }
        }
        
        var image: UIImage {
            switch self {
            case .companion:
                return .imgCheck
            case .diningMap:
                return .imgCheck
            case .matching:
                return .imgCheck
            case .meeting:
                return .imgCheck
            case .myPage:
                return .imgCheck
            }
        }
    }
    
    func makeNavigationController(for item: TabItem) -> UINavigationController {
        let viewController = makeRootViewController(for: item)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(
            title: item.title,
            image: item.image,
            selectedImage: nil
        )
        
        return navigationController
    }
    
    func makeRootViewController(for item: TabItem) -> UIViewController {
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
