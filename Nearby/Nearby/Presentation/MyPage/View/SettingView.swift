//
//  SettingView.swift
//  Nearby
//
//  Created by 신서연 on 7/10/26.
//

import UIKit

import SnapKit
import Then

final class SettingView: BaseView {

    // MARK: - Property

    private let isGuest: Bool

    // MARK: - UI Components

    let navigationBar = NearbyNavigationBar()
    let logoutButton = UIButton(type: .system)
    let agreementButton = UIButton(type: .system)
    let withdrawalButton = UIButton(type: .system)
    private let dividerView = UIView()
    private let versionLabel = UILabel()
    private let menuContainerView = UIView()
    private let logoutIconImageView = UIImageView()
    private let termsIconImageView = UIImageView()

    // MARK: - Initializer

    init(isGuest: Bool = false) {
        self.isGuest = isGuest
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        [logoutButton, logoutIconImageView, dividerView, withdrawalButton].forEach { $0.isHidden = isGuest }

        navigationBar.do {
            $0.configure(leftItem: .back, centerItem: .title("설정"))
        }

        menuContainerView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
        }

        logoutIconImageView.do {
            $0.image = UIImage(named: "logoutIcon")
            $0.contentMode = .scaleAspectFit
        }

        termsIconImageView.do {
            $0.image = UIImage(named: "termsIcon")
            $0.contentMode = .scaleAspectFit
        }

        logoutButton.do {
            $0.setTitle("로그아웃", for: .normal)
            $0.setTitleColor(.grey80, for: .normal)
            $0.titleLabel?.font = NearbyFont.b3M14.font
            $0.contentHorizontalAlignment = .leading
        }

        agreementButton.do {
            $0.setTitle("약관 및 정책", for: .normal)
            $0.setTitleColor(.grey80, for: .normal)
            $0.titleLabel?.font = NearbyFont.b3M14.font
            $0.contentHorizontalAlignment = .leading
        }

        dividerView.do {
            $0.backgroundColor = .grey10
        }

        versionLabel.do {
            $0.text = "v.1.0.0"
            $0.font = NearbyFont.c1R12.font
            $0.textColor = .grey50
            $0.textAlignment = .center
        }

        withdrawalButton.do {
            $0.setTitle("탈퇴하기", for: .normal)
            $0.setTitleColor(.systemRed, for: .normal)
            $0.titleLabel?.font = NearbyFont.b3M14.font
        }
    }

    override func setUI() {
        addSubviews(navigationBar, menuContainerView, versionLabel, withdrawalButton)
        menuContainerView.addSubviews(logoutIconImageView, logoutButton, dividerView, termsIconImageView, agreementButton)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }

        menuContainerView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(isGuest ? 52 : 105)
        }

        logoutIconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalTo(logoutButton)
            $0.width.equalTo(14.09)
            $0.height.equalTo(16.12)
        }

        logoutButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(logoutIconImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }

        dividerView.snp.makeConstraints {
            $0.top.equalTo(logoutButton.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }

        termsIconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalTo(agreementButton)
            $0.width.equalTo(17)
            $0.height.equalTo(20.5)
        }

        agreementButton.snp.makeConstraints {
            if isGuest {
                $0.top.equalToSuperview()
            } else {
                $0.top.equalTo(dividerView.snp.bottom)
            }
            $0.leading.equalTo(termsIconImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }

        versionLabel.snp.makeConstraints {
            $0.top.equalTo(menuContainerView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }

        withdrawalButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(44)
        }
    }
}
