//
//  PhoneVerificationViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/6/26.
//

import UIKit

final class PhoneVerificationViewController: BaseViewController<PhoneVerificationViewModel> {

    // MARK: - UI Component

    private let phoneVerificationView = PhoneVerificationView()

    // MARK: - Life Cycles

    override func loadView() {
        self.view = phoneVerificationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setAddTarget()
    }

    // MARK: - Custom Method

    private func bindViewModel() {
        viewModel.output.isVerificationMode = { [weak self] isVerificationMode in
            self?.phoneVerificationView.updateVerificationMode(isVerificationMode)
        }
    }

    private func setAddTarget() {
        phoneVerificationView.backButton.addTarget(
            self,
            action: #selector(backButtonDidTap),
            for: .touchUpInside
        )

        phoneVerificationView.bottomButton.addTarget(
            self,
            action: #selector(bottomButtonDidTap),
            for: .touchUpInside
        )

        phoneVerificationView.phoneClearButton.addTarget(
            self,
            action: #selector(phoneClearButtonDidTap),
            for: .touchUpInside
        )

        phoneVerificationView.verificationClearButton.addTarget(
            self,
            action: #selector(verificationClearButtonDidTap),
            for: .touchUpInside
        )
    }

    // MARK: - Actions

    @objc
    private func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func bottomButtonDidTap() {
        viewModel.action(.bottomButtonDidTap)
    }

    @objc
    private func phoneClearButtonDidTap() {
        phoneVerificationView.clearPhoneText()
    }

    @objc
    private func verificationClearButtonDidTap() {
        phoneVerificationView.clearVerificationText()
    }
}
