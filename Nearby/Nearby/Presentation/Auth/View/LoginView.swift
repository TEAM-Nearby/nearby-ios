//
//  LoginView.swift
//  Nearby
//
//  Created by 신서연 on 7/6/26.
//

import UIKit

import SnapKit
import Then

final class LoginView: BaseView {

    // MARK: - UI Components

    let kakaoLoginButton = UIButton(type: .system)
    
    private let logoStackView = UIStackView()
    private let logoImageView = UIImageView()
    private let subtitleLabel = UILabel()

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        logoStackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 7
        }
        
        logoImageView.do {
            $0.image = .nearbyLogo
            $0.contentMode = .scaleAspectFit
        }

        subtitleLabel.do {
            $0.textAlignment = .center
            $0.setFont(.b2Sb16, text: "따로, 또 함께하는 여행", textColor: .grey70)
        }

        kakaoLoginButton.do {
            $0.backgroundColor = UIColor(red: 254 / 255, green: 229 / 255, blue: 0 / 255, alpha: 1)
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true

            var configuration = UIButton.Configuration.plain()
            configuration.image = .iconKakao
            configuration.imagePlacement = .leading
            configuration.imagePadding = 16
            configuration.baseForegroundColor = .black
            configuration.title = "카카오 로그인"

            configuration.titleTextAttributesTransformer =
                UIConfigurationTextAttributesTransformer { attributes in
                    var updatedAttributes = attributes
                    updatedAttributes.font = NearbyFont.b2Sb16.font
                    updatedAttributes.foregroundColor = UIColor.black
                    return updatedAttributes
                }

            $0.configuration = configuration
        }
    }

    override func setUI() {
        addSubviews(logoStackView, kakaoLoginButton)

        logoStackView.addArrangedSubviews(logoImageView, subtitleLabel)
    }

    override func setLayout() {
        logoStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-70)
        }

        logoImageView.snp.makeConstraints {
            $0.width.equalTo(172)
            $0.height.equalTo(48)
        }

        kakaoLoginButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }

        kakaoLoginButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
    }
}
