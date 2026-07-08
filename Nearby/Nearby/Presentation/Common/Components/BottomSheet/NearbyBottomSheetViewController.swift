//
//  NearbyBottomSheetViewController.swift
//  Nearby
//
//  Created by soomin on 7/7/26.
//

import UIKit

import SnapKit
import Then

final class NearbyBottomSheetViewController: BaseViewController<EmptyViewModel> {

    // MARK: - UI Components

    private let containerView = UIView()
    private let clippedContentView = UIView()
    private let topControlView = UIView()
    private let contentWrapperView = UIView()

    // MARK: - Properties

    private var currentContentViewController: UIViewController?
    private var currentBottomSheetType: BottomSheetType = BottomSheetType.companionEmpty
    private var containerHeight: CGFloat = 0
    private var panStartHeight: CGFloat = 0

    var onHeightChange: ((CGFloat, BottomSheetType) -> Void)?

    // MARK: - Life Cycles

    override func loadView() {
        let passthroughView = BottomSheetPassthroughView()
        passthroughView.shouldHandleBackgroundTouch = { [weak self] in
            guard let self else { return false }
            return currentBottomSheetType.isDraggable && !self.currentBottomSheetType.isSmallType
        }
        view = passthroughView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setGesture()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard shouldResolveHeightFromSuperview(for: currentBottomSheetType) else { return }

        let resolvedHeight = resolvedHeight(for: currentBottomSheetType)
        guard abs(containerHeight - resolvedHeight) > 0.5 else { return }

        containerHeight = resolvedHeight
        containerView.snp.updateConstraints {
            $0.height.equalTo(resolvedHeight)
        }
        onHeightChange?(resolvedHeight, currentBottomSheetType)
    }

    // MARK: - Custom Methods

    override func setStyle() {
        view.backgroundColor = .clear

        containerView.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 30
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.25
            $0.layer.shadowRadius = 10
            $0.layer.shadowOffset = CGSize(width: 0, height: -3)
        }

        clippedContentView.do {
            $0.backgroundColor = .white
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 30
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }

        topControlView.do {
            $0.backgroundColor = .border.withAlphaComponent(0.1)
            $0.layer.cornerRadius = 2
        }
    }

    override func setUI() {
        view.addSubview(containerView)
        containerView.addSubview(clippedContentView)
        clippedContentView.addSubviews(topControlView, contentWrapperView)
    }

    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(containerHeight)
        }

        clippedContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        topControlView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(47)
            $0.height.equalTo(4)
        }

        contentWrapperView.snp.makeConstraints {
            $0.top.equalTo(topControlView.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }

    // MARK: - Methods

    private func setGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        containerView.addGestureRecognizer(panGesture)

        let backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap(_:)))
        view.addGestureRecognizer(backgroundTapGesture)
    }

    private func clampedHeight(_ height: CGFloat) -> CGFloat {
        guard let minType = currentBottomSheetType.snapTypes.first,
              let maxType = currentBottomSheetType.snapTypes.last else {
            return height
        }

        let minHeight = resolvedHeight(for: minType)
        let maxHeight = resolvedHeight(for: maxType)
        return min(maxHeight, max(minHeight, height))
    }

    private func nearestBottomSheetType(to height: CGFloat) -> BottomSheetType {
        currentBottomSheetType.snapTypes.min {
            abs(resolvedHeight(for: $0) - height) < abs(resolvedHeight(for: $1) - height)
        } ?? currentBottomSheetType
    }

    private func resolvedHeight(for bottomSheetType: BottomSheetType) -> CGFloat {
        switch bottomSheetType {
        case .nearbyCompanionBig, .specificCompanionBig:
            return max(0, availableHeight - topSafeAreaInset - 48)
        case .diningMapFullScreen:
            return availableHeight
        default:
            return bottomSheetType.fixedHeight ?? 0
        }
    }

    private func shouldResolveHeightFromSuperview(for bottomSheetType: BottomSheetType) -> Bool {
        switch bottomSheetType {
        case .nearbyCompanionBig, .specificCompanionBig, .diningMapFullScreen:
            return true
        default:
            return false
        }
    }

    private var availableHeight: CGFloat {
        let height = view.superview?.bounds.height ?? view.bounds.height
        return height > 0 ? height : UIScreen.main.bounds.height
    }

    private var topSafeAreaInset: CGFloat {
        max(view.superview?.safeAreaInsets.top ?? 0, view.safeAreaInsets.top)
    }

    private func nextBottomSheetType(translationY: CGFloat, velocityY: CGFloat) -> BottomSheetType {
        let snapTypes = currentBottomSheetType.snapTypes
        guard let smallType = snapTypes.first,
              let bigType = snapTypes.last,
              snapTypes.count >= 2 else {
            return currentBottomSheetType
        }

        let projectedHeight = clampedHeight(panStartHeight - translationY - velocityY * 0.18)
        let smallHeight = resolvedHeight(for: smallType)
        let bigHeight = resolvedHeight(for: bigType)

        if currentBottomSheetType == smallType,
           translationY < -(bigHeight - smallHeight) * 0.35 || velocityY < -1200 {
            return bigType
        }

        if currentBottomSheetType == bigType,
           translationY > (bigHeight - smallHeight) * 0.35 || velocityY > 1200 {
            return smallType
        }

        return nearestBottomSheetType(to: projectedHeight)
    }

    func configureSheetHeight(
        preset: BottomSheetType,
        animated: Bool = false
    ) {
        currentBottomSheetType = preset
        updateSheetLayout(animated: animated)
    }

    func updateSheetLayout(animated: Bool = true) {
        let bottomSheetHeight = resolvedHeight(for: currentBottomSheetType)

        containerHeight = bottomSheetHeight
        containerView.snp.updateConstraints {
            $0.height.equalTo(bottomSheetHeight)
        }

        let animations = {
            self.view.layoutIfNeeded()
        }

        if animated {
            UIView.animate(withDuration: 0.28, delay: 0, usingSpringWithDamping: 0.86,
                           initialSpringVelocity: 0.4, options: [.curveEaseOut], animations: animations)
        } else {
            animations()
        }

        onHeightChange?(bottomSheetHeight, currentBottomSheetType)
    }

    func setContentViewController(_ viewController: UIViewController) {
        if let existingViewControlelr = currentContentViewController {
            existingViewControlelr.willMove(toParent: nil)
            existingViewControlelr.view.removeFromSuperview()
            existingViewControlelr.removeFromParent()
        }

        addChild(viewController)
        contentWrapperView.addSubview(viewController.view)

        viewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        viewController.didMove(toParent: self)
        currentContentViewController = viewController
    }

    // MARK: - Actions

    @objc
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard currentBottomSheetType.isDraggable else { return }

        switch gesture.state {
        case .began:
            panStartHeight = containerHeight
        case .changed:
            let translationY = gesture.translation(in: view).y
            let targetHeight = clampedHeight(panStartHeight - translationY)

            containerHeight = targetHeight
            containerView.snp.updateConstraints {
                $0.height.equalTo(targetHeight)
            }
            view.layoutIfNeeded()
            onHeightChange?(targetHeight, currentBottomSheetType)
        case .ended, .cancelled, .failed:
            currentBottomSheetType = nextBottomSheetType(
                translationY: gesture.translation(in: view).y,
                velocityY: gesture.velocity(in: view).y
            )
            updateSheetLayout(animated: true)
        default:
            break
        }
    }

    @objc
    private func backgroundDidTap(_ gesture: UITapGestureRecognizer) {
        guard currentBottomSheetType.isDraggable, !currentBottomSheetType.isSmallType else { return }
        guard !containerView.frame.contains(gesture.location(in: view)) else { return }
        guard !currentBottomSheetType.isThirdStep else { return }

        configureSheetHeight(preset: currentBottomSheetType.smallType, animated: true)
    }
}

private final class BottomSheetPassthroughView: UIView {
    var shouldHandleBackgroundTouch: (() -> Bool)?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)

        if hitView == self {
            return shouldHandleBackgroundTouch?() == true ? self : nil
        }

        return hitView
    }
}
