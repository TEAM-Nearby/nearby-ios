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
        configureTabBarAppearance()
    }
    
    // MARK: - Method
    
    private func configureTabBarAppearance() {
        let barAppearance = UITabBarAppearance()
        barAppearance.configureWithOpaqueBackground()
        barAppearance.backgroundColor = .bgTadBarGrey
        
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
        
        barAppearance.stackedItemPositioning = .centered
        barAppearance.stackedItemWidth = 52
        barAppearance.stackedItemSpacing = 20
        barAppearance.stackedLayoutAppearance = itemAppearance
        barAppearance.inlineLayoutAppearance = itemAppearance
        barAppearance.compactInlineLayoutAppearance = itemAppearance
        
        tabBar.standardAppearance = barAppearance
        tabBar.scrollEdgeAppearance = barAppearance
        tabBar.tintColor = .grey80
        tabBar.unselectedItemTintColor = .grey60
        tabBar.isTranslucent = false
        tabBar.layer.cornerRadius = 30
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.grey10.cgColor
        tabBar.layer.masksToBounds = true
    }
}
