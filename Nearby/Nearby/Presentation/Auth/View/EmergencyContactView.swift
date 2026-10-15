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
        }

        nameClearButton.do {
            $0.setImage(.cancelIcon.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .grey80
            $0.isHidden = true
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
            $0.isHidden = true
        }

        policyContainerView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 16
        }

        policyTitleLabel.do {
            $0.setFont(.b3Sb14, text: "비상연락망 정책 안내", textColor: .grey80)
        }

        policyDescriptionLabel.do {
            $0.numberOfLines = 0
            $0.setFont(.c1R12, text: "• 비상연락망은 안전한 동행을 위해 사용돼요.\n• 긴급 상황 발생 시 등록된 연락처로 연락할 수 있어요.", textColor: .grey60)
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
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        policyDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(policyTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }

        bottomButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(14)
            $0.height.equalTo(56)
        }
    }

    // MARK: - Methods

    func updateClearButtons() {
        nameClearButton.isHidden = nameTextField.text?.isEmpty ?? true
        phoneClearButton.isHidden = phoneTextField.text?.isEmpty ?? true
    }

    func updateBottomButton(isEnabled: Bool) {
        bottomButton.isEnabled = isEnabled
    }
}
