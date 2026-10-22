//
//  GuestLoginGuideView.swift
//  Nearby
//
//  Created by soomin on 10/21/26.
//

import UIKit

import SnapKit
import Then

final class GuestLoginGuideView: BaseView {

    // MARK: - UI Components

    let loginButton = NearbyButton(style: .primary, title: "로그인하고 동행 구하기")

    private let topControlView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let profileImageView = UIImageView()
    private let balloonImageView = UIImageView()

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        topControlView.do {
            $0.backgroundColor = .border.withAlphaComponent(0.1)
            $0.layer.cornerRadius = 2
            $0.isAccessibilityElement = false
        }

        titleLabel.do {
            $0.setFont(.h3Sb20, text: "동행을 구하려면 로그인이 필요해요", textColor: .grey80)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        descriptionLabel.do {
            $0.setFont(.b3M14, text: "함께할 동행에게 보여줄 프로필을 먼저 작성해주세요.\n혼밥지도는 프로필 없이도 사용하실 수 있어요!", textColor: .grey50)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        profileImageView.do {
            $0.image = .imgProfileDefault
            $0.contentMode = .scaleAspectFit
        }
        
        balloonImageView.do {
            $0.image = UIImage(resource: .talkBallon)
            $0.contentMode = .scaleAspectFit
        }

    }

    override func setUI() {
        addSubviews(topControlView, titleLabel, descriptionLabel, profileImageView, loginButton, balloonImageView)
    }

    override func setLayout() {
        topControlView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(47)
            $0.height.equalTo(4)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(120)
        }
        
        balloonImageView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(39)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(loginButton.snp.top).offset(4)
            $0.width.equalTo(130)
            $0.height.equalTo(48)
        }

        loginButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
    }
    // MARK: - Method

    func configureForGeneralFeature() {
        loginButton.setTitle("로그인하러 가기", for: .normal)
        titleLabel.setFont(.h3Sb20, text: "로그인이 필요한 기능이에요", textColor: .grey80)
        descriptionLabel.setFont(.b3M14, text: "로그인하고 Nearby의 다양한 기능을 이용해보세요.\n간편하게 로그인하고 바로 시작할 수 있어요!", textColor: .grey50)
    }
}
