//
//  GuestAgreementView.swift
//  Nearby
//
//  Created by soomin on 10/21/26.
//

import UIKit

import SnapKit
import Then

final class GuestAgreementView: BaseView {

    // MARK: - UI Components

    let serviceTermsButton = UIButton(type: .custom)
    let locationTermsButton = UIButton(type: .custom)
    private let serviceTermsStackView = UIStackView()
    private let locationTermsStackView = UIStackView()
    let agreeButton = NearbyButton(style: .primary, title: "동의하기")

    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let serviceTermsLabel = UILabel()
    private let serviceTermsChevronImageView = UIImageView()
    private let locationTermsLabel = UILabel()
    private let locationTermsChevronImageView = UIImageView()

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        accessibilityViewIsModal = true

        serviceTermsButton.do {
            $0.accessibilityLabel = "서비스 이용약관 동의 (필수)"
            $0.accessibilityHint = "약관 상세 내용을 엽니다"
        }
        locationTermsButton.do {
            $0.accessibilityLabel = AgreementDetailType.location.title
            $0.accessibilityHint = "약관 상세 내용을 엽니다"
        }

        contentView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 24
            $0.layer.cornerCurve = .continuous
        }
        
        titleLabel.do {
            $0.setFont(.h3Sb20, text: "필수 약관에 동의해주세요", textColor: .grey80)
            $0.numberOfLines = 0
        }
        
        descriptionLabel.do {
            $0.setFont(.b3M14, text: "현재 위치를 기반으로 니어바이의 지도 서비스를 사용할 수 있어요!", textColor: .grey50)
            $0.numberOfLines = 0
        }
        
        serviceTermsStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 4
            $0.isUserInteractionEnabled = false
            $0.accessibilityElementsHidden = true
        }

        serviceTermsLabel.do {
            $0.setFont(.b3R14, text: "서비스 이용약관 동의 (필수)", textColor: .grey40)
            $0.numberOfLines = 0
        }

        serviceTermsChevronImageView.do {
            $0.image = .chevronRightIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .grey40
            $0.contentMode = .scaleAspectFit
        }

        locationTermsStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 4
            $0.isUserInteractionEnabled = false
            $0.accessibilityElementsHidden = true
        }

        locationTermsLabel.do {
            $0.setFont(.b3R14, text: AgreementDetailType.location.title, textColor: .grey40)
            $0.numberOfLines = 0
        }

        locationTermsChevronImageView.do {
            $0.image = .chevronRightIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .grey40
            $0.contentMode = .scaleAspectFit
        }
    }

    override func setUI() {
        serviceTermsStackView.addArrangedSubviews(serviceTermsLabel, serviceTermsChevronImageView)
        locationTermsStackView.addArrangedSubviews(locationTermsLabel, locationTermsChevronImageView)
        addSubview(contentView)
        contentView.addSubviews(titleLabel, descriptionLabel, serviceTermsButton, locationTermsButton, agreeButton)
        serviceTermsButton.addSubview(serviceTermsStackView)
        locationTermsButton.addSubview(locationTermsStackView)
    }

    override func setLayout() {
        serviceTermsStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        locationTermsStackView.snp.makeConstraints { $0.edges.equalToSuperview() }

        contentView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(31)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(46)
        }
        
        serviceTermsButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.leading.equalTo(titleLabel)
            $0.trailing.lessThanOrEqualToSuperview().inset(24)
            $0.height.greaterThanOrEqualTo(20)
        }

        serviceTermsChevronImageView.snp.makeConstraints {
            $0.size.equalTo(12)
        }

        locationTermsButton.snp.makeConstraints {
            $0.top.equalTo(serviceTermsButton.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel)
            $0.trailing.lessThanOrEqualToSuperview().inset(24)
            $0.height.greaterThanOrEqualTo(20)
        }
        
        locationTermsChevronImageView.snp.makeConstraints {
            $0.size.equalTo(12)
        }
        
        agreeButton.snp.makeConstraints {
            $0.top.equalTo(locationTermsButton.snp.bottom).offset(13)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
}
