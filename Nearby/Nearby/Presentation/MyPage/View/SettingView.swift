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

    private let dividerView = UIView()

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

        dividerView.do {
            $0.backgroundColor = .grey10
        }
    }

    override func setUI() {
        addSubview(navigationBar)
        addSubview(logoutButton)
        addSubview(dividerView)
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
    }
}
