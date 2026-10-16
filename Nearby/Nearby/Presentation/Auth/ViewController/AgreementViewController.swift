//
//  AgreementViewController.swift
//  Nearby
//
//  Created by 신서연 on 10/9/26.
//

import UIKit

final class AgreementViewController: BaseViewController<AgreementViewModel> {

    // MARK: - Property

    private let agreementView = AgreementView()
    var onAgreementDetailRequested: ((AgreementDetailType) -> Void)?
    var onBackButtonDidTap: (() -> Void)?
    var onAgreementCompleted: (() -> Void)?

    // MARK: - Life Cycle

    override func loadView() {
        view = agreementView
    }

    // MARK: - Custom Methods

    override func setAddTarget() {
        agreementView.allAgreementButton.addTarget(self, action: #selector(allAgreementDidTap), for: .touchUpInside)

        agreementView.locationAgreementButton.addTarget(self, action: #selector(locationAgreementDidTap), for: .touchUpInside)

        agreementView.privacyAgreementButton.addTarget(self, action: #selector(privacyAgreementDidTap), for: .touchUpInside)

        agreementView.marketingAgreementButton.addTarget(self, action: #selector(marketingAgreementDidTap), for: .touchUpInside)
        
        agreementView.locationDetailButton.addTarget(self, action: #selector(locationDetailButtonDidTap), for: .touchUpInside)

        agreementView.privacyDetailButton.addTarget(self, action: #selector(privacyDetailButtonDidTap), for: .touchUpInside)

        agreementView.marketingDetailButton.addTarget(self, action: #selector(marketingDetailButtonDidTap), for: .touchUpInside)
        
        agreementView.bottomButton.addTarget(self, action: #selector(agreementButtonDidTap), for: .touchUpInside)

    }

    override func bindState() {
        viewModel.output.onAgreementStateChanged = { [weak self] state in
            guard let self else { return }

            agreementView.updateAgreementButton(agreementView.allAgreementButton, isSelected: state.isAllAgreed)

            agreementView.updateAgreementButton(agreementView.locationAgreementButton, isSelected: state.isLocationAgreed)

            agreementView.updateAgreementButton(agreementView.privacyAgreementButton, isSelected: state.isPrivacyAgreed)

            agreementView.updateAgreementButton(agreementView.marketingAgreementButton, isSelected: state.isMarketingAgreed)

            agreementView.bottomButton.isEnabled = state.isAgreeButtonEnabled
        }
        
        viewModel.output.onAgreementDetailRequested = { [weak self] type in
            self?.onAgreementDetailRequested?(type)
        }

    }
    
    override func bindAction() {
        super.bindAction()

        agreementView.navigationBar.leftButtonAction = { [weak self] in
            self?.onBackButtonDidTap?()
        }
    }

    // MARK: - Actions

    @objc
    private func allAgreementDidTap() {
        viewModel.action(.allAgreementDidTap)
    }

    @objc
    private func locationAgreementDidTap() {
        viewModel.action(.locationAgreementDidTap)
    }

    @objc
    private func privacyAgreementDidTap() {
        viewModel.action(.privacyAgreementDidTap)
    }

    @objc
    private func marketingAgreementDidTap() {
        viewModel.action(.marketingAgreementDidTap)
    }
    
    @objc
    private func locationDetailButtonDidTap() {
        viewModel.action(.locationDetailDidTap)
    }

    @objc
    private func privacyDetailButtonDidTap() {
        viewModel.action(.privacyDetailDidTap)
    }

    @objc
    private func marketingDetailButtonDidTap() {
        viewModel.action(.marketingDetailDidTap)
    }
    
    @objc
    private func agreementButtonDidTap() {
        onAgreementCompleted?()
    }

}
