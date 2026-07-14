//
//  SplashViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/13/26.
//

import UIKit

final class SplashViewController: BaseViewController<EmptyViewModel> {
    
    // MARK: - Properties
    
    var onSplashCompleted: (() -> Void)?

    private var hasStartedAnimation = false
    
    // MARK: - UI Component
    
    private let splashView = SplashView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = splashView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        playSplashAnimation()
    }
    
    // MARK: - Methods
    
    private func playSplashAnimation() {
        guard !hasStartedAnimation else { return }
        
        hasStartedAnimation = true
        
        splashView.playAnimation { [weak self] in
            self?.onSplashCompleted?()
        }
    }
}
