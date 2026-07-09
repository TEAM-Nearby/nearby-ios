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

    // MARK: - UI Components

    let navigationBar = NearbyNavigationBar()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds
    }

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

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

        scrollView.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
        }

        contentView.do {
            $0.backgroundColor = .clear
        }
    }

    override func setUI() {
        layer.insertSublayer(gradientLayer, at: 0)

        addSubview(scrollView)
        addSubview(navigationBar)

        scrollView.addSubview(contentView)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(1200) // 임시 테스트용임
        }
    }
}
