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

    let navigationBar = NearbyNavigationBar()

    private let progressContainerView = UIView()
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

    let bottomButton = NearbyButton(style: .primary, title: "인증문자 발송하기")

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        navigationBar.do {
            $0.configure(leftItem: .back)
        }
        
        progressContainerView.do {
            $0.backgroundColor = .white
        }

        progressView.do {
            $0.progress = 0.5
            $0.progressTintColor = .btnPrimaryBg
            $0.trackTintColor = .chipBgPurple
            $0.layer.cornerRadius = 5.5
            $0.clipsToBounds = true
        }

        titleLabel.do {
            $0.numberOfLines = 2
            $0.setFont(.h3Sb20, text: "더 안전한 니어바이를 위해\n휴대폰 본인인증을 진행해주세요", textColor: .grey80)
            $0.setLineSpacing(lineSpacing: 6)
        }

        phoneTitleLabel.do {
            $0.setRequiredTitle("전화번호")
        }

        phoneTextFieldContainerView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }

        phoneTextField.do {
            $0.placeholder = "전화번호를 입력해주세요"
            $0.keyboardType = .numberPad
            $0.borderStyle = .none
            $0.font = NearbyFont.b3M14.font
            $0.textColor = .grey80
            $0.attributedPlaceholder = NSAttributedString(
                string: "전화번호를 입력해주세요",
                attributes: [.foregroundColor: UIColor.grey20]
            )
        }

        phoneClearButton.do {
            $0.setImage(.cancelIcon.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .grey20
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
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
            $0.isHidden = true
        }

        verificationTextField.do {
            $0.placeholder = "인증번호를 입력해주세요"
            $0.keyboardType = .numberPad
            $0.borderStyle = .none
            $0.font = NearbyFont.b3M14.font
            $0.textColor = .grey80
            $0.attributedPlaceholder = NSAttributedString(
                string: "인증번호를 입력해주세요",
                attributes: [.foregroundColor: UIColor.grey20]
            )
        }

        verificationClearButton.do {
            $0.setImage(.cancelIcon.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .grey20
        }

        verificationErrorLabel.do {
            $0.setFont(.b3R14, text: "인증번호가 일치하지 않아요", textColor: .highlightRed)
            $0.isHidden = true
        }
    }

    override func setUI() {
        addSubviews(navigationBar, progressContainerView, titleLabel,
            phoneTitleLabel, phoneTextFieldContainerView, phoneErrorLabel,
            verificationTitleLabel, verificationTextFieldContainerView,
            verificationErrorLabel,bottomButton
        )

        progressContainerView.addSubview(progressView)

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
        
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        progressContainerView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(11)
        }

        progressView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(4)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressContainerView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(28)
        }

        phoneTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(52)
            $0.leading.equalToSuperview().offset(28)
        }

        phoneTextFieldContainerView.snp.makeConstraints {
            $0.top.equalTo(phoneTitleLabel.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(28)
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
            $0.horizontalEdges.equalToSuperview().inset(28)
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
            $0.horizontalEdges.equalToSuperview().inset(28)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
    }

    func updateVerificationMode(_ isVerificationMode: Bool) {
        progressView.progress = isVerificationMode ? 1.0 : 0.5

        phoneClearButton.isHidden = !isVerificationMode
        phoneErrorLabel.isHidden = true

        verificationTitleLabel.isHidden = !isVerificationMode
        verificationTextFieldContainerView.isHidden = !isVerificationMode
        verificationErrorLabel.isHidden = true

        bottomButton.setTitle(
            isVerificationMode ? "다음" : "인증문자 발송하기",
            for: .normal
        )
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
                .foregroundColor: UIColor.grey80,
                .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
            ]
        )

        attributedString.append(
            NSAttributedString(
                string: "*",
                attributes: [
                    .foregroundColor: UIColor.highlightRed,
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
