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
    private var currentState = BottomSheetState(content: .nearbyCompanionEmpty)
    private var containerHeight: CGFloat = 0
    private var panStartHeight: CGFloat = 0
    
    var onStateChange: ((CGFloat, BottomSheetState) -> Void)?
    
    private var availableHeight: CGFloat {
        let height = view.superview?.bounds.height ?? view.bounds.height
        return height > 0 ? height : (view.window?.windowScene?.screen.bounds.height ?? 0)
    }
    
    private var topSafeAreaInset: CGFloat {
        max(view.superview?.safeAreaInsets.top ?? 0, view.safeAreaInsets.top)
    }
    
    private var tabBarHeight: CGFloat {
        return tabBarController?.tabBar.bounds.height ?? 0
    }
    
    private var heightContext: NearbyBottomSheetHeightContext {
        NearbyBottomSheetHeightContext(availableHeight: availableHeight, topSafeAreaInset: topSafeAreaInset, tabBarHeight: tabBarHeight)
    }
    
    // MARK: - Life Cycles
    
    override func loadView() {
        let passthroughView = BottomSheetPassthroughView()
        view = passthroughView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let resolvedHeight = resolvedHeight(for: currentState)
        guard abs(containerHeight - resolvedHeight) > 0.5 else { return }
        
        containerHeight = resolvedHeight
        containerView.snp.updateConstraints {
            $0.height.equalTo(resolvedHeight)
        }
        onStateChange?(resolvedHeight, currentState)
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
            $0.top.equalToSuperview().offset(8)
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
    }
    
    private func clampedHeight(_ height: CGFloat) -> CGFloat {
        guard let minLevel = currentState.availableLevels.first,
              let maxLevel = currentState.availableLevels.last else {
            return height
        }
        
        let minHeight = resolvedHeight(for: BottomSheetState(content: currentState.content, level: minLevel))
        let maxHeight = resolvedHeight(for: BottomSheetState(content: currentState.content, level: maxLevel))
        return min(maxHeight, max(minHeight, height))
    }
    
    private func nearestLevel(to height: CGFloat) -> BottomSheetLevel {
        currentState.availableLevels.min {
            let leftState = BottomSheetState(content: currentState.content, level: $0)
            let rightState = BottomSheetState(content: currentState.content, level: $1)
            return abs(resolvedHeight(for: leftState) - height) < abs(resolvedHeight(for: rightState) - height)
        } ?? currentState.level
    }
    
    private func resolvedHeight(for state: BottomSheetState) -> CGFloat {
        NearbyBottomSheetHeightResolver.height(for: state, context: heightContext)
    }
    
    private func nextLevel(translationY: CGFloat, velocityY: CGFloat) -> BottomSheetLevel {
        let levels = currentState.availableLevels
        guard let firstLevel = levels.first,
              let lastLevel = levels.last,
              levels.count >= 2 else {
            return currentState.level
        }
        
        let projectedHeight = clampedHeight(panStartHeight - translationY - velocityY * 0.18)
        let firstHeight = resolvedHeight(for: BottomSheetState(content: currentState.content, level: firstLevel))
        let lastHeight = resolvedHeight(for: BottomSheetState(content: currentState.content, level: lastLevel))
        
        if currentState.level == firstLevel,
           translationY < -(lastHeight - firstHeight) * 0.35 || velocityY < -1200 {
            return lastLevel
        }
        
        if currentState.level == lastLevel,
           translationY > (lastHeight - firstHeight) * 0.35 || velocityY > 1200 {
            return firstLevel
        }
        
        return nearestLevel(to: projectedHeight)
    }

    func setTopOverlayViews(centerView: UIView, trailingView: UIView) {
        view.addSubviews(centerView, trailingView)

        centerView.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(containerView.snp.top).offset(-12)
        }

        trailingView.snp.remakeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(centerView)
            $0.size.equalTo(40)
        }
    }
    
    func setState(
        content: BottomSheetContent,
        level: BottomSheetLevel? = nil,
        animated: Bool = false
    ) {
        setState(BottomSheetState(content: content, level: level), animated: animated)
    }
    
    func setState(_ state: BottomSheetState, animated: Bool = false) {
        currentState = state
        updateSheetLayout(animated: animated)
    }
    
    func updateSheetLayout(animated: Bool = true) {
        let bottomSheetHeight = resolvedHeight(for: currentState)
        
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
        
        onStateChange?(bottomSheetHeight, currentState)
    }
    
    func setContentViewController(_ viewController: UIViewController) {
        if let existingViewController = currentContentViewController {
            existingViewController.willMove(toParent: nil)
            existingViewController.view.removeFromSuperview()
            existingViewController.removeFromParent()
        }
        
        addChild(viewController)
        contentWrapperView.addSubview(viewController.view)
        
        viewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        viewController.didMove(toParent: self)
        currentContentViewController = viewController
    }
    
    // MARK: - Action
    
    @objc
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard currentState.isDraggable else { return }
        
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
            onStateChange?(targetHeight, currentState)
        case .ended, .cancelled, .failed:
            currentState = BottomSheetState(
                content: currentState.content,
                level: nextLevel(
                    translationY: gesture.translation(in: view).y,
                    velocityY: gesture.velocity(in: view).y
                )
            )
            updateSheetLayout(animated: true)
        default:
            break
        }
    }
}
