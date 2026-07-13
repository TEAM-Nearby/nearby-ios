//
//  SplashView.swift
//  Nearby
//
//  Created by 신서연 on 7/13/26.
//

import UIKit

import Lottie
import SnapKit
import Then

final class SplashView: BaseView {

    // MARK: - Properties

    private enum Layout {
        static let logoTopOffset: CGFloat = 213
        static let logoWidth: CGFloat = 172
        static let logoHeight: CGFloat = 48

        static let subtitleTopOffset: CGFloat = 7
        static let animationTopOffset: CGFloat = 56

        static let animationContainerWidth: CGFloat = 272.64
        static let animationContainerHeight: CGFloat = 179.5

        static let animationCanvasSize: CGFloat = 394

        static let animationCenterYOffset: CGFloat = -18
    }

    // MARK: - UI Components

    private let gradientLayer = CAGradientLayer()

    private let logoImageView = UIImageView()
    private let subtitleLabel = UILabel()

    private let animationContainerView = UIView()
    private let animationView = LottieAnimationView(name: "Splash")

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor(red: 185 / 255, green: 174 / 255, blue: 250 / 255, alpha: 1).cgColor
        ]

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.opacity = 0.17

        logoImageView.do {
            $0.image = .nearbyLogo
            $0.contentMode = .scaleAspectFit
        }

        subtitleLabel.do {
            $0.textAlignment = .center
            $0.numberOfLines = 1
            $0.setFont(.b2Sb16, text: "따로, 또 함께하는 여행", textColor: .grey70)
        }

        animationContainerView.do {
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
        }

        animationView.do {
            $0.backgroundColor = .clear
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .playOnce
            $0.backgroundBehavior = .pauseAndRestore
        }
    }

    override func setUI() {
        layer.insertSublayer(gradientLayer, at: 0)
        addSubviews(logoImageView, subtitleLabel, animationContainerView)
        animationContainerView.addSubview(animationView)
    }

    override func setLayout() {
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Layout.logoTopOffset)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Layout.logoWidth)
            $0.height.equalTo(Layout.logoHeight)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(Layout.subtitleTopOffset)
            $0.centerX.equalToSuperview()
        }

        animationContainerView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(Layout.animationTopOffset)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Layout.animationContainerWidth)
            $0.height.equalTo(Layout.animationContainerHeight)
        }

        animationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(Layout.animationCenterYOffset)
            $0.width.equalTo(Layout.animationCanvasSize)
            $0.height.equalTo(Layout.animationCanvasSize)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds
    }

    // MARK: - Method

    func playAnimation(completion: @escaping () -> Void) {
        animationView.play { finished in
            guard finished else { return }

            completion()
        }
    }
}
