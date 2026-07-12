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
        view = phoneVerificationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Custom Method

    override func setAddTarget() {
        phoneVerificationView.navigationBar.leftButtonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        phoneVerificationView.bottomButton.addTarget(self, action: #selector(bottomButtonDidTap), for: .touchUpInside)
        phoneVerificationView.phoneClearButton.addTarget(self, action: #selector(phoneClearButtonDidTap), for: .touchUpInside)
        phoneVerificationView.verificationClearButton.addTarget(self, action: #selector(verificationClearButtonDidTap), for: .touchUpInside)
    }

    private func bindViewModel() {
        viewModel.output.isVerificationMode = { [weak self] isVerificationMode in
            self?.phoneVerificationView.updateVerificationMode(isVerificationMode)
        }
    }

    // MARK: - Actions

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
