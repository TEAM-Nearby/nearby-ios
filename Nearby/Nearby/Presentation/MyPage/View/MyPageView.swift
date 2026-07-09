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

    private let boardingPassImageView = UIImageView()

    private let mannerScoreCardView = UIView()
    private let menuCardView = UIView()

    private let writtenPostRowView = MyPageMenuRowView(title: "내가 작성한 모집글")
    private let sentRequestRowView = MyPageMenuRowView(title: "보낸 요청")
    private let receivedRequestRowView = MyPageMenuRowView(title: "받은 요청")

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
            $0.alwaysBounceVertical = true
        }

        contentView.do {
            $0.backgroundColor = .clear
        }

        boardingPassImageView.do {
            $0.image = .mypageCard
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }

        mannerScoreCardView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }

        menuCardView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }
    }

    override func setUI() {
        layer.insertSublayer(gradientLayer, at: 0)

        addSubview(scrollView)
        addSubview(navigationBar)

        scrollView.addSubview(contentView)

        contentView.addSubview(boardingPassImageView)
        contentView.addSubview(mannerScoreCardView)
        contentView.addSubview(menuCardView)

        menuCardView.addSubview(writtenPostRowView)
        menuCardView.addSubview(sentRequestRowView)
        menuCardView.addSubview(receivedRequestRowView)
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
        }

        boardingPassImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(408)
        }

        mannerScoreCardView.snp.makeConstraints {
            $0.top.equalTo(boardingPassImageView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.greaterThanOrEqualTo(209)
        }

        menuCardView.snp.makeConstraints {
            $0.top.equalTo(mannerScoreCardView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.greaterThanOrEqualTo(160)
            $0.bottom.equalToSuperview().inset(12)
        }

        writtenPostRowView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(53)
        }

        sentRequestRowView.snp.makeConstraints {
            $0.top.equalTo(writtenPostRowView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(53)
        }

        receivedRequestRowView.snp.makeConstraints {
            $0.top.equalTo(sentRequestRowView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
            $0.bottom.equalToSuperview()
        }
    }
}

private final class MyPageMenuRowView: UIView {

    // MARK: - UI Components

    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView()

    // MARK: - Initializer

    init(title: String) {
        super.init(frame: .zero)

        setStyle(title: title)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MyPageMenuRowView {
    func setStyle(title: String) {
        backgroundColor = .clear

        titleLabel.do {
            $0.setFont(.b2M16, text: title, textColor: .grey80)
        }

        arrowImageView.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = .grey70
            $0.contentMode = .scaleAspectFit
        }
    }

    func setUI() {
        addSubview(titleLabel)
        addSubview(arrowImageView)
    }

    func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }

        arrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(13)
            $0.height.equalTo(23)
        }
    }
}
