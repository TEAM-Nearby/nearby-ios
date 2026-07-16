//
//  UIViewController+.swift
//  Nearby
//
//  Created by soomin on 7/2/26.
//

import UIKit

final class InitialLoadingTracker {
    private var isLoading = false
    private var hasCompleted = false
    private var ownsIndicator = false

    func begin(in viewController: UIViewController) {
        guard !isLoading, !hasCompleted else { return }
        isLoading = true
        ownsIndicator = viewController.showInitialLoadingIndicator()
    }

    func complete(in viewController: UIViewController) {
        guard isLoading else { return }
        isLoading = false
        hasCompleted = true
        if ownsIndicator {
            viewController.hideInitialLoadingIndicator()
            ownsIndicator = false
        }
    }
}

extension UIViewController {
    private static var initialLoadingOverlayTag: Int { 9_070_716 }

    func addKeyboardDismissGesture() {
        let tapped = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tapped.cancelsTouchesInView = false
        view.addGestureRecognizer(tapped)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }

    @discardableResult
    func showInitialLoadingIndicator() -> Bool {
        guard let hostView = view else { return false }
        guard hostView.viewWithTag(Self.initialLoadingOverlayTag) == nil else { return false }

        let overlayView = UIView()
        overlayView.tag = Self.initialLoadingOverlayTag
        overlayView.backgroundColor = .clear
        overlayView.isUserInteractionEnabled = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false

        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.startAnimating()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false

        overlayView.addSubview(indicatorView)
        hostView.addSubview(overlayView)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: hostView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: hostView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: hostView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: hostView.bottomAnchor),
            indicatorView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
        ])
        return true
    }

    func hideInitialLoadingIndicator() {
        view.viewWithTag(Self.initialLoadingOverlayTag)?.removeFromSuperview()
    }
}
