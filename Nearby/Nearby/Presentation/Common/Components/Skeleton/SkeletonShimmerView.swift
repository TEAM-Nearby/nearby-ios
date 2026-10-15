//
//  SkeletonShimmerView.swift
//  Nearby
//
//  Created by soomin on 10/14/26.
//

import UIKit

final class SkeletonShimmerContainerView: UIView {

    // MARK: - Properties

    private let gradientLayer = CAGradientLayer()
    private let skeletonMaskLayer = CAShapeLayer()
    private let animationKey = "skeleton.shimmer"

    override var isHidden: Bool {
        didSet { updateAnimation() }
    }

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGradient()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds
        updateSkeletonMask()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateAnimation()
    }

    // MARK: - Methods

    private func configureGradient() {
        isUserInteractionEnabled = false
        accessibilityElementsHidden = true

        gradientLayer.colors = [
            UIColor.bgSurfaceGrey0.cgColor,
            UIColor.white.cgColor,
            UIColor.bgSurfaceGrey0.cgColor
        ]
        gradientLayer.locations = [-1, -0.5, 0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.mask = skeletonMaskLayer
        layer.addSublayer(gradientLayer)
    }

    private func updateSkeletonMask() {
        let path = UIBezierPath()

        subviews.compactMap { $0 as? SkeletonShimmerView }.forEach { skeletonView in
            path.append(UIBezierPath(roundedRect: skeletonView.frame, cornerRadius: skeletonView.skeletonCornerRadius))
        }

        skeletonMaskLayer.frame = bounds
        skeletonMaskLayer.path = path.cgPath
    }

    private func updateAnimation() {
        guard window != nil, !isHidden else {
            gradientLayer.removeAnimation(forKey: animationKey)
            return
        }
        guard gradientLayer.animation(forKey: animationKey) == nil else { return }

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1, -0.5, 0]
        animation.toValue = [1, 1.5, 2]
        animation.duration = 1.17
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        gradientLayer.add(animation, forKey: animationKey)
    }
}

final class SkeletonShimmerView: BaseView {
    let skeletonCornerRadius: CGFloat

    init(cornerRadius: CGFloat) {
        skeletonCornerRadius = cornerRadius
        super.init(frame: .zero)
        isUserInteractionEnabled = false
        accessibilityElementsHidden = true
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
