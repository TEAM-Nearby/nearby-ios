//
//  AgreementDetailViewController.swift
//  Nearby
//
//  Created by 신서연 on 10/16/26.
//

import UIKit

final class AgreementDetailViewController: BaseViewController<AgreementDetailViewModel> {

    // MARK: - UI Component

    private let agreementDetailView = AgreementDetailView()

    // MARK: - Life Cycles

    override func loadView() {
        view = agreementDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.action(.viewDidLoad)
    }

    // MARK: - Custom Methods

    override func bindState() {
        super.bindState()

        viewModel.output.onAgreementDetailLoaded = { [weak self] title, content in
            self?.agreementDetailView.configure(title: title, content: content)
        }
    }
}

