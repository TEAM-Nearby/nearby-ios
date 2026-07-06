//
//  PhoneVerificationView.swift
//  Nearby
//
//  Created by 신서연 on 7/6/26.
//

import UIKit

import SnapKit
import Then

final class PhoneVerificationView: BaseView {

    // MARK: - UI Components

    let backButton = UIButton(type: .system)

    private let progressView = UIProgressView(progressViewStyle: .default)

    private let titleLabel = UILabel()

    private let phoneTitleLabel = UILabel()
    private let phoneTextFieldContainerView = UIView()
    let phoneTextField = UITextField()
    let phoneClearButton = UIButton(type: .system)
    private let phoneErrorLabel = UILabel()

    private let verificationTitleLabel = UILabel()
    private let verificationTextFieldContainerView = UIView()
    let verificationTextField = UITextField()
    let verificationClearButton = UIButton(type: .system)
    private let verificationErrorLabel = UILabel()

    let bottomButton = NearbyButton(
        style: .primary,
        title: "인증문자 발송하기"
    )

    // MARK: - Properties

    private var isVerificationMode = false

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        backButton.do {
            $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            $0.tintColor = .grey80
        }

        progressView.do {
            $0.progress = 0.5
            $0.progressTintColor = .btnPrimaryBg
            $0.trackTintColor = .chipBgPurple
            $0.layer.cornerRadius = 2
            $0.clipsToBounds = true
        }

        titleLabel.do {
            $0.numberOfLines = 2
            $0.setFont(
                .h3Sb20,
                text: "더 안전한 니어바이를 위해\n휴대폰 본인인증을 진행해주세요",
                textColor: .grey80
            )
            $0.setLineSpacing(lineSpacing: 6)
        }

        phoneTitleLabel.do {
            $0.setRequiredTitle("전화번호")
        }

        phoneTextFieldContainerView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
        }

        phoneTextField.do {
            $0.placeholder = "전화번호를 입력해주세요"
            $0.keyboardType = .numberPad
            $0.borderStyle = .none
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.textColor = UIColor(red: 36/255, green: 36/255, blue: 36/255, alpha: 1)
            $0.attributedPlaceholder = NSAttributedString(
                string: "전화번호를 입력해주세요",
                attributes: [
                    .foregroundColor: UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
                ]
            )
        }

        phoneClearButton.do {
            $0.setImage(UIImage(systemName: "xmark"), for: .normal)
            $0.tintColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
            $0.isHidden = true
        }

        phoneErrorLabel.do {
            $0.setFont(.b3R14, text: "올바른 전화번호 형식이 아니에요", textColor: .highlightRed)
            $0.isHidden = true
        }

        verificationTitleLabel.do {
            $0.setRequiredTitle("인증번호")
            $0.isHidden = true
        }

        verificationTextFieldContainerView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
            $0.isHidden = true
        }

        verificationTextField.do {
            $0.placeholder = "인증번호를 입력해주세요"
            $0.keyboardType = .numberPad
            $0.borderStyle = .none
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.textColor = UIColor(red: 36/255, green: 36/255, blue: 36/255, alpha: 1)
            $0.attributedPlaceholder = NSAttributedString(
                string: "인증번호를 입력해주세요",
                attributes: [
                    .foregroundColor: UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
                ]
            )
        }

        verificationClearButton.do {
            $0.setImage(UIImage(systemName: "xmark"), for: .normal)
            $0.tintColor = .grey20
        }

        verificationErrorLabel.do {
            $0.setFont(.b3R14, text: "인증번호가 일치하지 않아요", textColor: .highlightRed)
            $0.isHidden = true
        }
    }

    override func setUI() {
        addSubviews(
            backButton,
            progressView,
            titleLabel,
            phoneTitleLabel,
            phoneTextFieldContainerView,
            phoneErrorLabel,
            verificationTitleLabel,
            verificationTextFieldContainerView,
            verificationErrorLabel,
            bottomButton
        )

        phoneTextFieldContainerView.addSubviews(
            phoneTextField,
            phoneClearButton
        )

        verificationTextFieldContainerView.addSubviews(
            verificationTextField,
            verificationClearButton
        )
    }

    override func setLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(18)
            $0.leading.equalToSuperview().offset(28)
            $0.size.equalTo(28)
        }

        progressView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(42)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(4)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(28)
        }

        phoneTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(52)
            $0.leading.equalToSuperview().offset(28)
        }

        phoneTextFieldContainerView.snp.makeConstraints {
            $0.top.equalTo(phoneTitleLabel.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(56)
        }

        phoneTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(28)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(phoneClearButton.snp.leading).offset(-12)
        }

        phoneClearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(28)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        phoneErrorLabel.snp.makeConstraints {
            $0.top.equalTo(phoneTextFieldContainerView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(28)
        }

        verificationTitleLabel.snp.makeConstraints {
            $0.top.equalTo(phoneErrorLabel.snp.bottom).offset(52)
            $0.leading.equalToSuperview().offset(28)
        }

        verificationTextFieldContainerView.snp.makeConstraints {
            $0.top.equalTo(verificationTitleLabel.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(56)
        }

        verificationTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(28)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(verificationClearButton.snp.leading).offset(-12)
        }

        verificationClearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(28)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        verificationErrorLabel.snp.makeConstraints {
            $0.top.equalTo(verificationTextFieldContainerView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(28)
        }

        bottomButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(22)
            $0.height.equalTo(56)
        }
    }

    func updateVerificationMode() {
        isVerificationMode = true

        progressView.setProgress(1.0, animated: true)

        phoneClearButton.isHidden = false
        phoneErrorLabel.isHidden = false

        verificationTitleLabel.isHidden = false
        verificationTextFieldContainerView.isHidden = false
        verificationErrorLabel.isHidden = false

        bottomButton.setTitle("다음", for: .normal)
    }

    func clearPhoneText() {
        phoneTextField.text = nil
    }

    func clearVerificationText() {
        verificationTextField.text = nil
    }
}

// MARK: - UILabel Extensions

private extension UILabel {
    func setRequiredTitle(_ title: String) {
        let attributedString = NSMutableAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor(red: 36/255, green: 36/255, blue: 36/255, alpha: 1),
                .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
            ]
        )

        attributedString.append(
            NSAttributedString(
                string: "*",
                attributes: [
                    .foregroundColor: UIColor(red: 255/255, green: 31/255, blue: 49/255, alpha: 1),
                    .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
                ]
            )
        )

        self.attributedText = attributedString
    }

    func setLineSpacing(lineSpacing: CGFloat) {
        guard let text = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: self.font as Any,
                .foregroundColor: self.textColor as Any
            ]
        )

        self.attributedText = attributedString
    }
}
