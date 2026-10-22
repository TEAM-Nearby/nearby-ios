//
//  GuestAgreementViewController.swift
//  Nearby
//
//  Created by soomin on 10/21/26.
//

import UIKit

final class GuestAgreementViewController: BaseViewController<EmptyViewModel> {

    // MARK: - Property

    var onAgree: (() -> Void)?

    // MARK: - UI Component

    private let agreementView = GuestAgreementView()

    // MARK: - Initializers

    override init(viewModel: EmptyViewModel = EmptyViewModel()) {
        super.init(viewModel: viewModel)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        isModalInPresentation = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycles

    override func loadView() {
        view = agreementView
    }

    // MARK: - Custom Methods

    override func setStyle() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }

    override func bindAction() {
        super.bindAction()
        let termsTapGesture = UITapGestureRecognizer(target: self, action: #selector(locationTermsDidTap))
        agreementView.locationTermsStackView.addGestureRecognizer(termsTapGesture)
        agreementView.agreeButton.addTarget(self, action: #selector(agreeButtonDidTap), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc
    private func locationTermsDidTap() {
        let detailViewController = AgreementDetailViewController(viewModel: AgreementDetailViewModel(agreementType: .location))
        detailViewController.onBackButtonDidTap = { [weak detailViewController] in
            detailViewController?.dismiss(animated: true)
        }
        detailViewController.modalPresentationStyle = .fullScreen
        detailViewController.transitioningDelegate = self
        present(detailViewController, animated: true)
    }

    @objc
    private func agreeButtonDidTap() {
        agreementView.agreeButton.isEnabled = false
        dismiss(animated: true, completion: onAgree)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension GuestAgreementViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        GuestAgreementDetailTransition(isPresenting: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        GuestAgreementDetailTransition(isPresenting: false)
    }
}

private final class GuestAgreementDetailTransition: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Property

    private let isPresenting: Bool

    // MARK: - Initializer

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }

    // MARK: - Methods

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to),
              let toViewController = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView
        toView.frame = transitionContext.finalFrame(for: toViewController)
        let translation = CGAffineTransform(translationX: containerView.bounds.width, y: 0)

        if isPresenting {
            containerView.addSubview(toView)
            toView.transform = translation
        } else {
            containerView.insertSubview(toView, belowSubview: fromView)
        }

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut) {
            if self.isPresenting {
                toView.transform = .identity
            } else {
                fromView.transform = translation
            }
        } completion: { _ in
            fromView.transform = .identity
            toView.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
