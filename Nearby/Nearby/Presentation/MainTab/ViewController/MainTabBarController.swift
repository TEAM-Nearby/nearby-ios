//
//  MainTabBarController.swift
//  Nearby
//
//  Created by soomin on 7/6/26.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        delegate = self
        configureTabBarAppearance()
    }
    
    // MARK: - Method
    
    private func configureTabBarAppearance() {
        let barAppearance = UITabBarAppearance()
        barAppearance.configureWithOpaqueBackground()
        barAppearance.backgroundColor = .white
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = .grey60
        itemAppearance.selected.iconColor = .grey80
        itemAppearance.normal.titleTextAttributes = [
            .font: NearbyFont.c1M12.font,
            .foregroundColor: UIColor.grey60
        ]
        itemAppearance.selected.titleTextAttributes = [
            .font: NearbyFont.c1Sb12.font,
            .foregroundColor: UIColor.grey80
        ]
        
        let offset = UIOffset(horizontal: 0, vertical: 12)
        itemAppearance.normal.titlePositionAdjustment = offset
        itemAppearance.selected.titlePositionAdjustment = offset
        
        barAppearance.stackedItemPositioning = .fill
        barAppearance.stackedLayoutAppearance = itemAppearance
        barAppearance.inlineLayoutAppearance = itemAppearance
        barAppearance.compactInlineLayoutAppearance = itemAppearance
        
        tabBar.standardAppearance = barAppearance
        tabBar.scrollEdgeAppearance = barAppearance
        tabBar.itemPositioning = .fill
        tabBar.backgroundColor = .clear
        tabBar.tintColor = .grey80
        tabBar.unselectedItemTintColor = .grey60
        tabBar.isTranslucent = true
        tabBar.layer.cornerRadius = 30
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.grey10.cgColor
        tabBar.layer.masksToBounds = true
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard selectedViewController !== viewController else { return true }

        let currentViewController = (selectedViewController as? UINavigationController)?.visibleViewController
            ?? selectedViewController
        (currentViewController as? MainTabSwitchPreparing)?.prepareForTabSwitch()

        viewController.loadViewIfNeeded()
        let destinationViewController = (viewController as? UINavigationController)?.visibleViewController
            ?? viewController
        destinationViewController.loadViewIfNeeded()
        destinationViewController.view.setNeedsLayout()
        destinationViewController.view.layoutIfNeeded()
        return true
    }
}
