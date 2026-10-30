//
//  NearbyNavigationController.swift
//  Nearby
//
//  Created by soomin on 7/16/26.
//

import UIKit

protocol SwipeBackDisabled {
    var isSwipeBackDisabled: Bool { get }
}

extension SwipeBackDisabled {
    var isSwipeBackDisabled: Bool { true }
}

final class NearbyNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }
}

extension NearbyNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1 && transitionCoordinator == nil && (topViewController as? SwipeBackDisabled)?.isSwipeBackDisabled != true
    }
}
