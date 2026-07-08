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
    
    private let contentStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let logoContainerView = UIView()
    private let logoLabel = UILabel()
    
    let kakaoLoginButton = UIButton(type: .system)
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .white
        
        contentStackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 8
        }
        
        titleLabel.do {
            $0.textAlignment = .center
            $0.setFont(.h1Sb24, text: "따로, 또 함께하는 여행", textColor: .grey80)
        }
        
        subtitleLabel.do {
            $0.textAlignment = .center
            $0.setFont(.b3M14, text: "지금 로그인하고 Nearby를 시작해보세요!", textColor: .grey50)
        }
        
        logoContainerView.do {
            $0.backgroundColor = .grey10
        }
        
        logoLabel.do {
            $0.textAlignment = .center
            $0.setFont(.b3R14, text: "로고", textColor: .black)
        }
        
        kakaoLoginButton.do {
            $0.setImage(.iconKakao.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    override func setUI() {
        addSubviews(contentStackView, kakaoLoginButton)
        
        contentStackView.addArrangedSubviews(titleLabel, subtitleLabel, logoContainerView
        )
        
        contentStackView.setCustomSpacing(36, after: subtitleLabel)
        
        logoContainerView.addSubview(logoLabel)
    }
    
    override func setLayout() {
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(253)
            $0.centerX.equalToSuperview()
        }
        
        logoContainerView.snp.makeConstraints {
            $0.width.equalTo(180)
            $0.height.equalTo(64)
        }
        
        logoLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(98)
            $0.size.equalTo(68)
        }
    }
}
