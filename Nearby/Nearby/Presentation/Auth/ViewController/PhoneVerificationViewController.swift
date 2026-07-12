//
//  PhoneVerificationViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/6/26.
//

import UIKit

final class PhoneVerificationViewController: BaseViewController<PhoneVerificationViewModel> {

    // MARK: - Property
    
    var onVerificationCompleted: (() -> Void)?
    
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
        phoneVerificationView.phoneTextField.addTarget(self, action: #selector(phoneTextFieldDidChange), for: .editingChanged)
        phoneVerificationView.verificationTextField.addTarget(self, action: #selector(verificationTextFieldDidChange), for: .editingChanged)
    }

    private func bindViewModel() {
        viewModel.output.isVerificationMode = { [weak self] isVerificationMode in
            self?.phoneVerificationView.updateVerificationMode(isVerificationMode)
        }
        
        viewModel.output.verificationDidComplete = { [weak self] in
            guard let self else { return }
            view.endEditing(true)
            onVerificationCompleted?()
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
        viewModel.action(.phoneNumberDidChange(""))
    }

    @objc
    private func verificationClearButtonDidTap() {
        phoneVerificationView.clearVerificationText()
        viewModel.action(.verificationCodeDidChange(""))
    }
    
    @objc
    private func phoneTextFieldDidChange() {
        let phoneNumber = phoneVerificationView.phoneTextField.text ?? ""
        viewModel.action(.phoneNumberDidChange(phoneNumber))
    }
    
    @objc
    private func verificationTextFieldDidChange() {
        let verificationCode = phoneVerificationView.verificationTextField.text ?? ""
        viewModel.action(.verificationCodeDidChange(verificationCode))
    }
}
