//
//  LoadingView.swift
//  Nearby
//
//  Created by soomin on 10/12/26.
//

import UIKit

import Lottie
import SnapKit
import Then

final class LoadingView: BaseView {
    
    // MARK: - Properties
    
    private let loadingLabel = UILabel()
    private let loadingAnimationView = LottieAnimationView(name: "Loading")
    private let loadingStackView = UIStackView()
    
    override var isHidden: Bool {
        didSet { updateAnimationPlayback() }
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        accessibilityViewIsModal = true

        loadingLabel.do {
            $0.setFont(.h1B20, text: "잠시만 기다려주세요", textColor: .white)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }

        loadingAnimationView.do {
            $0.backgroundColor = .clear
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .loop
            $0.backgroundBehavior = .pauseAndRestore
            $0.viewportFrame = CGRect(x: 0, y: 335, width: 1000, height: 339)
            $0.clipsToBounds = true
            $0.isAccessibilityElement = false
        }

        loadingStackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 32
        }
    }

    override func setUI() {
        loadingStackView.addArrangedSubviews(loadingLabel, loadingAnimationView)
        addSubviews(loadingStackView)
    }

    override func setLayout() {
        loadingStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().inset(24)
            $0.trailing.lessThanOrEqualToSuperview().inset(24)
        }

        loadingAnimationView.snp.makeConstraints {
            $0.width.equalTo(252)
            $0.height.equalTo(100.8)
        }
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateAnimationPlayback()
    }
    
    // MARK: - Methods

    private func updateAnimationPlayback() {
        if window != nil && !isHidden {
            guard !loadingAnimationView.isAnimationPlaying else { return }
            loadingAnimationView.play()
        } else {
            loadingAnimationView.stop()
        }
    }

    func configure(message: String, isFullScreen: Bool = false) {
        backgroundColor = isFullScreen ? .white : UIColor.black.withAlphaComponent(0.5)
        loadingLabel.setFont(.h1B20, text: message, textColor: isFullScreen ? .grey80 : .white)
        loadingLabel.textAlignment = .center
    }
}
