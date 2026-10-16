//
//  TermsListViewController.swift
//  Nearby
//
//  Created by 신서연 on 10/16/26.
//

import UIKit

final class TermsListViewController: BaseViewController<TermsListViewModel> {

    // MARK: - Properties

    var onBackButtonDidTap: (() -> Void)?
    var onTermsDidTap: ((AgreementDetailType) -> Void)?

    // MARK: - UI Component

    private let termsListView = TermsListView()

    // MARK: - Life Cycles

    override func loadView() {
        view = termsListView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Custom Methods

    override func setAddTarget() {
        super.setAddTarget()

        termsListView.navigationBar.leftButtonAction = { [weak self] in
            self?.viewModel.action(.backButtonDidTap)
        }

        termsListView.onTermsDidTap = { [weak self] type in
            self?.viewModel.action(.termsDidTap(type))
        }
    }

    override func bindAction() {
        super.bindAction()

        viewModel.output.backButtonDidTap = { [weak self] in
            self?.onBackButtonDidTap?()
        }

        viewModel.output.termsDidTap = { [weak self] type in
            self?.onTermsDidTap?(type)
        }
    }
}
