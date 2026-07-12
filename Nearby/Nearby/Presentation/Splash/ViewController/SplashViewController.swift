//
//  SplashViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/13/26.
//

import UIKit

final class SplashViewController: UIViewController {

    // MARK: - Properties

    var onAnimationCompleted: (() -> Void)?

    private var didPlayAnimation = false

    // MARK: - UI Component

    private let splashView = SplashView()

    // MARK: - Life Cycles

    override func loadView() {
        view = splashView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard !didPlayAnimation else { return }
        didPlayAnimation = true

        splashView.playAnimation { [weak self] in
            self?.onAnimationCompleted?()
        }
    }
}
