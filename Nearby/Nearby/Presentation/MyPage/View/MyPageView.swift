//
//  MyPageView.swift
//  Nearby
//
//  Created by 신서연 on 7/9/26.
//

import UIKit

import SnapKit
import Then

final class MyPageView: BaseView {

    // MARK: - Property

    private let gradientLayer = CAGradientLayer()

    // MARK: - UI Component

    let navigationBar = NearbyNavigationBar()

    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds
    }

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .clear

        gradientLayer.do {
            $0.colors = [
                UIColor(red: 220 / 255, green: 215 / 255, blue: 255 / 255, alpha: 1).cgColor,
                UIColor(red: 250 / 255, green: 250 / 255, blue: 255 / 255, alpha: 1).cgColor
            ]
            $0.startPoint = CGPoint(x: 0.5, y: 0.0)
            $0.endPoint = CGPoint(x: 0.5, y: 1.0)
        }

        navigationBar.do {
            $0.backgroundColor = .clear
            $0.configure(
                centerItem: .title("마이페이지"),
                rightItems: [.alarm, .setting]
            )
        }
    }

    override func setUI() {
        layer.insertSublayer(gradientLayer, at: 0)

        addSubview(navigationBar)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
