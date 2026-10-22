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

    let appleLoginButton = UIButton(type: .system)
    let kakaoLoginButton = UIButton(type: .system)
    let guestLoginButton = UIButton(type: .system)
    
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
        
        appleLoginButton.do {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true

            var configuration = UIButton.Configuration.plain()
            configuration.image = .iconApple
            configuration.preferredSymbolConfigurationForImage =
                UIImage.SymbolConfiguration(pointSize: 24)
            configuration.imagePlacement = .leading
            configuration.imagePadding = 16
            configuration.baseForegroundColor = .white
            configuration.title = "Apple로 로그인"
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0)

            configuration.titleTextAttributesTransformer =
                UIConfigurationTextAttributesTransformer { attributes in
                    var updatedAttributes = attributes
                    updatedAttributes.font = NearbyFont.b2Sb16.font
                    updatedAttributes.foregroundColor = UIColor.white
                    return updatedAttributes
                }

            $0.configuration = configuration
            $0.contentHorizontalAlignment = .center
        }
        
        kakaoLoginButton.do {
            $0.backgroundColor = UIColor(red: 254 / 255, green: 229 / 255, blue: 0 / 255, alpha: 1)
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true

            var configuration = UIButton.Configuration.plain()
            configuration.image = .iconKakao
            configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 24)
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

        guestLoginButton.do {
            $0.setTitle("게스트로 시작하기", for: .normal)
            $0.setTitleColor(.grey50, for: .normal)
            $0.titleLabel?.font = NearbyFont.b2M16.font
            $0.setUnderline(gap: 0.5, thickness: 1.3)
        }
    }

    override func setUI() {
        addSubviews(logoStackView, appleLoginButton, kakaoLoginButton, guestLoginButton)
        logoStackView.addArrangedSubviews(logoImageView, subtitleLabel)
    }

    override func setLayout() {
        logoStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(276)
            $0.centerX.equalToSuperview()
        }

        logoImageView.snp.makeConstraints {
            $0.width.equalTo(172)
            $0.height.equalTo(48)
        }

        appleLoginButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(kakaoLoginButton.snp.top).offset(-12)
            $0.height.equalTo(56)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(guestLoginButton.snp.top).offset(-12)
            $0.height.equalTo(56)
        }

        guestLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4)
            $0.height.equalTo(42)
            $0.width.equalTo(139)
        }
    }
}
