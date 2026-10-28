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
    let agreeButton = NearbyButton(style: .primary, title: "동의하기")

    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        accessibilityViewIsModal = true

        serviceTermsButton.do {
            $0.configuration = termsConfiguration(title: "서비스 이용약관 동의 (필수)")
            $0.contentHorizontalAlignment = .leading
        }

        locationTermsButton.do {
            $0.configuration = termsConfiguration(title: AgreementDetailType.location.title)
            $0.contentHorizontalAlignment = .leading
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
    }

    override func setUI() {
        addSubview(contentView)
        contentView.addSubviews(titleLabel, descriptionLabel, serviceTermsButton, locationTermsButton, agreeButton)
    }

    override func setLayout() {
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
        }

        locationTermsButton.snp.makeConstraints {
            $0.top.equalTo(serviceTermsButton.snp.bottom).offset(6)
            $0.leading.equalTo(titleLabel)
            $0.trailing.lessThanOrEqualToSuperview().inset(24)
        }

        agreeButton.snp.makeConstraints {
            $0.top.equalTo(locationTermsButton.snp.bottom).offset(13)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    // MARK: - Method

    private func termsConfiguration(title: String) -> UIButton.Configuration {
        let imageSize = CGSize(width: 12, height: 12)
        let image = UIGraphicsImageRenderer(size: imageSize).image { _ in
            UIImage.chevronRightIcon.draw(in: CGRect(origin: .zero, size: imageSize))
        }
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(
            title, attributes: AttributeContainer([.font: NearbyFont.b3R14.font])
        )
        configuration.baseForegroundColor = .grey40
        configuration.image = image.withRenderingMode(.alwaysTemplate)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 4
        configuration.contentInsets = .zero
        configuration.titleAlignment = .leading
        configuration.titleLineBreakMode = .byWordWrapping
        return configuration
    }
}
  
