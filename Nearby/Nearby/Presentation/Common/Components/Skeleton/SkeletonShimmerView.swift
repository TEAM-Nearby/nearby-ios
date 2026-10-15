//
//  SkeletonShimmerView.swift
//  Nearby
//
//  Created by soomin on 10/14/26.
//

import UIKit

final class SkeletonShimmerContainerView: BaseView {

    // MARK: - Properties

    private let skeletonLayer = CALayer()
    private let gradientLayer = CAGradientLayer()
    private let skeletonMaskLayer = CAShapeLayer()
    private let animationKey = "skeleton.shimmer"

    override var isHidden: Bool {
        didSet { updateAnimation() }
    }

    // MARK: - Life Cycles

    override func layoutSubviews() {
        super.layoutSubviews()

        updateLayers()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateAnimation()
    }

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white
        isHidden = true
        isUserInteractionEnabled = false
        accessibilityElementsHidden = true

        skeletonLayer.backgroundColor = UIColor.bgSurfaceGrey0.cgColor
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.cgColor,
            UIColor.clear.cgColor
        ]
    }

    override func setUI() {
        skeletonLayer.mask = skeletonMaskLayer
        skeletonLayer.addSublayer(gradientLayer)
        layer.addSublayer(skeletonLayer)
    }

    override func setLayout() {
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
    }

    // MARK: - Methods

    private func updateLayers() {
        let shimmerWidth = max(bounds.width * 0.7, 1)

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        skeletonLayer.frame = bounds
        gradientLayer.frame = CGRect(x: -shimmerWidth, y: 0, width: shimmerWidth, height: bounds.height)
        CATransaction.commit()

        updateSkeletonMask()
        restartAnimationIfNeeded()
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

        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = 0
        animation.toValue = bounds.width + gradientLayer.bounds.width
        animation.duration = 1.17
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        gradientLayer.add(animation, forKey: animationKey)
    }

    private func restartAnimationIfNeeded() {
        guard gradientLayer.animation(forKey: animationKey) != nil else {
            updateAnimation()
            return
        }

        gradientLayer.removeAnimation(forKey: animationKey)
        updateAnimation()
    }
}

final class SkeletonShimmerView: BaseView {

    // MARK: - Properties

    let skeletonCornerRadius: CGFloat

    // MARK: - Initializer

    init(cornerRadius: CGFloat) {
        skeletonCornerRadius = cornerRadius
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    override func setStyle() {
        isUserInteractionEnabled = false
        accessibilityElementsHidden = true
        backgroundColor = .clear
    }
}
