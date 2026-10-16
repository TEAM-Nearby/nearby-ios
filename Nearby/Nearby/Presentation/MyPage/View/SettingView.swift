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

    // MARK: - UI Components

    let navigationBar = NearbyNavigationBar()
    let logoutButton = UIButton(type: .system)
    let agreementButton = UIButton(type: .system)
    let withdrawalButton = UIButton(type: .system)
    private let dividerView = UIView()
    private let versionLabel = UILabel()

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        navigationBar.do {
            $0.configure(leftItem: .back, centerItem: .title("설정"))
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
            $0.text = "v.0.0.0"
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
        addSubviews(navigationBar, logoutButton, dividerView, agreementButton, versionLabel, withdrawalButton)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }

        logoutButton.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(49)
        }

        dividerView.snp.makeConstraints {
            $0.top.equalTo(logoutButton.snp.bottom).offset(3)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        agreementButton.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(3)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(49)
        }
        
        versionLabel.snp.makeConstraints {
            $0.top.equalTo(agreementButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        withdrawalButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(44)
        }
    }
}
