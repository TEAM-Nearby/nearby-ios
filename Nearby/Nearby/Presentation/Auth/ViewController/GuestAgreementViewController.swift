//
//  GuestAgreementViewController.swift
//  Nearby
//
//  Created by soomin on 10/21/26.
//

import UIKit

final class GuestAgreementViewController: BaseViewController<EmptyViewModel> {

    // MARK: - Properties

    var onAgree: (() -> Void)?
    private var detailDismissInteraction: UIPercentDrivenInteractiveTransition?

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
        
        agreementView.serviceTermsButton.addTarget(self, action: #selector(serviceTermsDidTap), for: .touchUpInside)
        agreementView.locationTermsButton.addTarget(self, action: #selector(locationTermsDidTap), for: .touchUpInside)
        agreementView.agreeButton.addTarget(self, action: #selector(agreeButtonDidTap), for: .touchUpInside)
    }

    // MARK: - Methods

    private func showAgreementDetail(type: AgreementDetailType) {
        let detailViewController = AgreementDetailViewController(viewModel: AgreementDetailViewModel(agreementType: type))
        detailViewController.onBackButtonDidTap = { [weak detailViewController] in
            detailViewController?.dismiss(animated: true)
        }
        let backGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(detailBackDidSwipe(_:)))
        backGesture.edges = .left
        detailViewController.view.addGestureRecognizer(backGesture)
        detailViewController.modalPresentationStyle = .fullScreen
        detailViewController.transitioningDelegate = self
        present(detailViewController, animated: true)
    }

    // MARK: - Actions

    @objc
    private func detailBackDidSwipe(_ gesture: UIScreenEdgePanGestureRecognizer) {
        guard let detailView = gesture.view else { return }
        let progress = min(max(gesture.translation(in: detailView).x / max(detailView.bounds.width, 1), 0), 1)

        switch gesture.state {
        case .began:
            guard let detail = presentedViewController,
                  !detail.isBeingPresented, !detail.isBeingDismissed else { return }
            let interaction = UIPercentDrivenInteractiveTransition()
            interaction.completionCurve = .easeOut
            detailDismissInteraction = interaction
            detail.dismiss(animated: true)
        case .changed:
            detailDismissInteraction?.update(progress)
        case .ended:
            if progress > 0.3 || gesture.velocity(in: detailView).x > 500 {
                detailDismissInteraction?.finish()
            } else {
                detailDismissInteraction?.cancel()
            }
            detailDismissInteraction = nil
        case .cancelled, .failed:
            detailDismissInteraction?.cancel()
            detailDismissInteraction = nil
        default:
            break
        }
    }

    @objc
    private func serviceTermsDidTap() {
        showAgreementDetail(type: .service)
    }

    @objc
    private func locationTermsDidTap() {
        showAgreementDetail(type: .location)
    }

    @objc
    private func agreeButtonDidTap() {
        agreementView.agreeButton.isEnabled = false
        dismiss(animated: true, completion: onAgree)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension GuestAgreementViewController: UIViewControllerTransitioningDelegate {
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        detailDismissInteraction
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        GuestAgreementDetailTransition(isPresenting: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        GuestAgreementDetailTransition(isPresenting: false)
    }
}

private final class GuestAgreementDetailTransition: NSObject {

    // MARK: - Property

    private let isPresenting: Bool

    // MARK: - Initializer

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }

}

// MARK: - UIViewControllerAnimatedTransitioning

extension GuestAgreementDetailTransition: UIViewControllerAnimatedTransitioning {
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
