//
//  EmergencyContactView.swift
//  Nearby
//
//  Created by 신서연 on 10/16/26.
//

import UIKit

import SnapKit
import Then

final class EmergencyContactView: BaseView {

    // MARK: - UI Components

    let navigationBar = NearbyNavigationBar()

    private let progressImageView = UIImageView()

    private let titleLabel = UILabel()

    private let nameTitleLabel = UILabel()
    private let nameTextFieldContainerView = UIView()
    let nameTextField = UITextField()
    let nameClearButton = UIButton(type: .system)

    private let phoneTitleLabel = UILabel()
    private let phoneTextFieldContainerView = UIView()
    let phoneTextField = UITextField()
    let phoneClearButton = UIButton(type: .system)

    private let policyContainerView = UIView()
    private let policyTitleLabel = UILabel()
    private let policyDescriptionLabel = UILabel()

    let bottomButton = NearbyButton(style: .primary, title: "프로필 설정 완료하기")

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        navigationBar.do {
            $0.configure(leftItem: .back)
        }

        progressImageView.do {
            $0.image = .progressStep3
            $0.contentMode = .scaleToFill
        }

        titleLabel.do {
            $0.numberOfLines = 2
            $0.setFont(.h3Sb20, text: "안전한 동행을 위해\n비상 연락망을 등록해주세요", textColor: .grey80)
        }

        nameTitleLabel.do {
            $0.setRequiredTitle("연락처명")
        }

        nameTextFieldContainerView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }

        nameTextField.do {
            $0.borderStyle = .none
            $0.font = NearbyFont.b3M14.font
            $0.textColor = .grey80
            $0.attributedPlaceholder = NSAttributedString(string: "연락처명을 입력해주세요", attributes: [.foregroundColor: UIColor.grey20])
            $0.returnKeyType = .done
        }

        nameClearButton.do {
            $0.setImage(.cancelIcon.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .grey80
            $0.isHidden = false
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
            $0.keyboardType = .numberPad
            $0.borderStyle = .none
            $0.font = NearbyFont.b3M14.font
            $0.textColor = .grey80
            $0.attributedPlaceholder = NSAttributedString(string: "-없이 숫자만 입력해주세요", attributes: [.foregroundColor: UIColor.grey20])
        }

        phoneClearButton.do {
            $0.setImage(.cancelIcon.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .grey80
            $0.isHidden = false
        }

        policyContainerView.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 0
        }

        policyTitleLabel.do {
            $0.setFont(.b2M16, text: "비상연락망 정책 안내", textColor: .grey40)
        }

        policyDescriptionLabel.do {
            $0.numberOfLines = 0
            $0.setFont(
                .b3R14,
                text: """
                • 비상 연락망은 안전을 위해서만 사용돼요
                • 다른 사용자에게 공개되지 않아요
                • 귀환 인증 실패 시에만 사용돼요
                • 언제든 수정·삭제할 수 있어요
                • 다른 사용자에게 공개되지 않아요
                • 귀환 인증 실패 시에만 사용돼요
                • 언제든 수정·삭제할 수 있어요
                """,
                textColor: .grey40
            )
            $0.setLineSpacing(lineSpacing: 12)
        }

        bottomButton.isEnabled = false
    }

    override func setUI() {
        addSubviews(navigationBar, progressImageView, titleLabel, nameTitleLabel, nameTextFieldContainerView, phoneTitleLabel, phoneTextFieldContainerView, policyContainerView, bottomButton)

        nameTextFieldContainerView.addSubviews(nameTextField, nameClearButton)

        phoneTextFieldContainerView.addSubviews(phoneTextField, phoneClearButton)

        policyContainerView.addSubviews(policyTitleLabel, policyDescriptionLabel)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
        }

        progressImageView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(4)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressImageView.snp.bottom).offset(26)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        nameTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(26)
            $0.leading.equalToSuperview().offset(20)
        }

        nameTextFieldContainerView.snp.makeConstraints {
            $0.top.equalTo(nameTitleLabel.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }

        nameTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(nameClearButton.snp.leading).offset(-12)
        }

        nameClearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        phoneTitleLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextFieldContainerView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(20)
        }

        phoneTextFieldContainerView.snp.makeConstraints {
            $0.top.equalTo(phoneTitleLabel.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }

        phoneTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(phoneClearButton.snp.leading).offset(-12)
        }

        phoneClearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        policyContainerView.snp.makeConstraints {
            $0.top.equalTo(phoneTextFieldContainerView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        policyTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }

        policyDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(policyTitleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        bottomButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(14)
            $0.height.equalTo(56)
        }
    }

    // MARK: - Methods

    func updateClearButtons() {
        nameClearButton.isHidden = false
        phoneClearButton.isHidden = false
    }

    func updateBottomButton(isEnabled: Bool) {
        bottomButton.isEnabled = isEnabled
    }
}

// MARK: - UILabel Extension

private extension UILabel {

    func setLineSpacing(lineSpacing: CGFloat) {
        guard let text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        attributedText = NSMutableAttributedString(string: text, attributes: [.paragraphStyle: paragraphStyle, .font: font as Any, .foregroundColor: textColor as Any])
    }
}
