//
//  PhoneVerificationViewController.swift
//  Nearby
//
//  Created by 신서연 on 7/6/26.
//

import UIKit

final class PhoneVerificationViewController: BaseViewController<PhoneVerificationViewModel> {

    // MARK: - Property

    private var isVerificationMode = false
    
    // MARK: - UI Component

    private let phoneVerificationView = PhoneVerificationView()

    // MARK: - Life Cycles

    override func loadView() {
        self.view = phoneVerificationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setAddTarget()
    }

    // MARK: - Custom Method

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
        if isVerificationMode {
            viewModel.action(.nextButtonDidTap)
            // TODO: - 다음 버튼 탭
            // print("다음 버튼 탭")
        } else {
            isVerificationMode = true
            phoneVerificationView.updateVerificationMode()
            viewModel.action(.sendVerificationButtonDidTap)
            // TODO: - 인증문자 발송하기 버튼 탭
            // print("인증문자 발송하기 버튼 탭")
        }
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
