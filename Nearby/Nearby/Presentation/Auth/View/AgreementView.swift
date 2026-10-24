//
//  AgreementView.swift
//  Nearby
//
//  Created by 신서연 on 10/9/26.
//

import UIKit

import SnapKit
import Then

final class AgreementView: BaseView {

    // MARK: - UI Components

    let navigationBar = NearbyNavigationBar()

    private let progressImageView = UIImageView()
    private let titleLabel = UILabel()
    
    private let agreementStackView = UIStackView()

    let allAgreementButton = UIButton(type: .system)
    let serviceAgreementButton = UIButton(type: .system)
    let locationAgreementButton = UIButton(type: .system)
    let privacyAgreementButton = UIButton(type: .system)
    let marketingAgreementButton = UIButton(type: .system)

    let serviceDetailButton = UIButton(type: .system)
    let locationDetailButton = UIButton(type: .system)
    let privacyDetailButton = UIButton(type: .system)
    let marketingDetailButton = UIButton(type: .system)

    let bottomButton = NearbyButton(style: .primary, title: "동의하기")

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        navigationBar.do {
            $0.configure(leftItem: .back)
        }

        progressImageView.do {
            $0.image = .progressStep1
            $0.contentMode = .scaleToFill
        }

        titleLabel.do {
            $0.numberOfLines = 0
            $0.setFont(.h3Sb20, text: "아래 약관에 동의하신 후\nNearby와 함께 여행을 시작하세요!", textColor: .grey80)
        }
        
        agreementStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
        }

        allAgreementButton.do {
            $0.contentHorizontalAlignment = .leading
        }

        var configuration = UIButton.Configuration.plain()

        configuration.image = fixedSizeCheckboxImage(.checkboxDefault).withRenderingMode(.alwaysOriginal)
        configuration.imagePlacement = .leading
        configuration.imagePadding = 15

        configuration.preferredSymbolConfigurationForImage = nil

        configuration.contentInsets = .zero

        configuration.attributedTitle = AttributedString("전체 약관 동의", attributes: AttributeContainer([.font: NearbyFont.b1M18.font, .foregroundColor: UIColor.grey80]))

        allAgreementButton.configuration = configuration
        
        serviceAgreementButton.do {
            $0.contentHorizontalAlignment = .leading
            $0.setTitle("서비스 이용약관 동의 (필수)", for: .normal)
            $0.setTitleColor(.grey80, for: .normal)
            $0.titleLabel?.font = NearbyFont.b2R16.font
        }

        locationAgreementButton.do {
            $0.contentHorizontalAlignment = .leading
            $0.setTitle("위치 기반 서비스 약관 동의 (필수)", for: .normal)
            $0.setTitleColor(.grey80, for: .normal)
            $0.titleLabel?.font = NearbyFont.b2R16.font
        }

        privacyAgreementButton.do {
            $0.contentHorizontalAlignment = .leading
            $0.setTitle("개인정보 수집 약관 동의 (필수)", for: .normal)
            $0.setTitleColor(.grey80, for: .normal)
            $0.titleLabel?.font = NearbyFont.b2R16.font
        }

        marketingAgreementButton.do {
            $0.contentHorizontalAlignment = .leading
            $0.setTitle("마케팅 정보 앱 푸시 알림 약관 동의 (선택)", for: .normal)
            $0.setTitleColor(.grey80, for: .normal)
            $0.titleLabel?.font = NearbyFont.b2R16.font
        }

        [serviceDetailButton, locationDetailButton, privacyDetailButton, marketingDetailButton].forEach {
            $0.setImage(UIImage.chevronRightIcon.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
        }

        [serviceAgreementButton, locationAgreementButton, privacyAgreementButton, marketingAgreementButton].forEach {
            var configuration = UIButton.Configuration.plain()

            configuration.image = fixedSizeCheckboxImage(.icCheckDefault).withRenderingMode(.alwaysOriginal)
            configuration.imagePlacement = .leading
            configuration.imagePadding = 15
            configuration.contentInsets = .zero
            configuration.baseForegroundColor = .grey80

            $0.configuration = configuration
            $0.contentHorizontalAlignment = .leading

            $0.configurationUpdateHandler = { button in
                var updatedConfiguration = button.configuration
                updatedConfiguration?.baseForegroundColor = .grey80
                button.configuration = updatedConfiguration
            }
        }

        bottomButton.isEnabled = false

    }

    override func setUI() {
        addSubviews(navigationBar, progressImageView, titleLabel, agreementStackView, bottomButton)
        
        let serviceRow = makeAgreementRow(agreementButton: serviceAgreementButton, detailButton: serviceDetailButton)
        let locationRow = makeAgreementRow(agreementButton: locationAgreementButton, detailButton: locationDetailButton)
        let privacyRow = makeAgreementRow(agreementButton: privacyAgreementButton, detailButton: privacyDetailButton)
        let marketingRow = makeAgreementRow(agreementButton: marketingAgreementButton, detailButton: marketingDetailButton)

        agreementStackView.addArrangedSubviews(allAgreementButton, serviceRow, locationRow, privacyRow, marketingRow)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
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
        
        agreementStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(bottomButton.snp.top).offset(-60)
        }

        allAgreementButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        bottomButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(14)
            $0.height.equalTo(56)
        }

    }
    
    private func makeAgreementRow(agreementButton: UIButton, detailButton: UIButton) -> UIView {
        let containerView = UIView()
        containerView.addSubviews(agreementButton, detailButton)

        agreementButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
            $0.trailing.lessThanOrEqualTo(detailButton.snp.leading).offset(-8)
        }

        detailButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }

        containerView.snp.makeConstraints {
            $0.height.equalTo(44)
        }

        return containerView
    }

    func updateAgreementButton(_ button: UIButton, isSelected: Bool) {
        let isAllAgreement = button === allAgreementButton

        let image: UIImage = if isAllAgreement {
            isSelected ? .checkboxSelect : .checkboxDefault
        } else {
            isSelected ? .icCheckSelect : .icCheckDefault
        }

        var configuration = button.configuration
        configuration?.image = fixedSizeCheckboxImage(image).withRenderingMode(.alwaysOriginal)

        button.configuration = configuration
    }
    
    private func fixedSizeCheckboxImage(_ image: UIImage) -> UIImage {
        let size = CGSize(width: 24, height: 24)

        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { _ in
            let origin = CGPoint(x: (size.width - image.size.width) / 2, y: (size.height - image.size.height) / 2)

            image.draw(at: origin)
        }
    }

}
