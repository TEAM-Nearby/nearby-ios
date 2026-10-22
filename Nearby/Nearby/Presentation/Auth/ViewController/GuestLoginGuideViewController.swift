//
//  GuestLoginGuideViewController.swift
//  Nearby
//
//  Created by soomin on 10/22/26.
//

import UIKit

import Then

final class GuestLoginGuideViewController: BaseViewController<EmptyViewModel> {

    // MARK: - Property

    var onLogin: (() -> Void)?

    // MARK: - UI Component

    private let guideView = GuestLoginGuideView()

    // MARK: - Initializers

    override init(viewModel: EmptyViewModel = EmptyViewModel()) {
        super.init(viewModel: viewModel)
        modalPresentationStyle = .pageSheet
        sheetPresentationController?.do {
            $0.detents = [.custom { [weak self] context in
                guard let self else { return nil }
                self.loadViewIfNeeded()
                let width = self.view.bounds.width > 0
                    ? self.view.bounds.width
                    : (self.presentingViewController?.view.bounds.width ?? 0)
                guard width > 0 else { return nil }
                let size = self.guideView.systemLayoutSizeFitting(
                    CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
                    withHorizontalFittingPriority: .required,
                    verticalFittingPriority: .fittingSizeLevel
                )
                return min(size.height - self.guideView.safeAreaInsets.bottom, context.maximumDetentValue)
            }]
            $0.prefersGrabberVisible = false
            $0.preferredCornerRadius = 24
            $0.prefersScrollingExpandsWhenScrolledToEdge = false
        }
    }

    convenience init(isGeneralFeature: Bool) {
        self.init(viewModel: EmptyViewModel())
        if isGeneralFeature {
            guideView.configureForGeneralFeature()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycles

    override func loadView() {
        view = guideView
    }

    // MARK: - Custom Methods

    override func bindAction() {
        super.bindAction()
        guideView.loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
    }

    // MARK: - Action

    @objc
    private func loginButtonDidTap() {
        guideView.loginButton.isEnabled = false
        dismiss(animated: true, completion: onLogin)
    }
}
