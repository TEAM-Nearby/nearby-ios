//
//  AlarmView.swift
//  Nearby
//
//  Created by 신서연 on 7/10/26.
//

import UIKit

import SnapKit
import Then

final class AlarmView: BaseView {

    // MARK: - UI Components

    let navigationBar = NearbyNavigationBar()

    private let tabContainerView = UIView()

    let sentRequestButton = UIButton(type: .system)
    let receivedRequestButton = UIButton(type: .system)

    private let bottomDividerView = UIView()

    private let sentRequestIndicatorView = UIView()
    private let receivedRequestIndicatorView = UIView()

    let requestTableView = UITableView(frame: .zero, style: .plain)

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        navigationBar.do {
            $0.configure(leftItem: .back, centerItem: .title("알림"))
        }

        tabContainerView.do {
            $0.backgroundColor = .white
        }

        sentRequestButton.do {
            $0.setTitle("보낸 요청", for: .normal)
            $0.titleLabel?.font = NearbyFont.b1Sb18.font
        }

        receivedRequestButton.do {
            $0.setTitle("받은 요청", for: .normal)
            $0.titleLabel?.font = NearbyFont.b1Sb18.font
        }

        bottomDividerView.do {
            $0.backgroundColor = .grey10
        }

        sentRequestIndicatorView.do {
            $0.backgroundColor = .grey80
        }

        receivedRequestIndicatorView.do {
            $0.backgroundColor = .grey80
        }

        requestTableView.do {
            $0.backgroundColor = .white
            $0.separatorStyle = .none

            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 150

            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = true

            $0.contentInset = UIEdgeInsets(top: 18, left: 0, bottom: 24, right: 0)

            $0.contentInsetAdjustmentBehavior = .never
        }
    }

    override func setUI() {
        addSubviews(
            navigationBar, tabContainerView, requestTableView
        )

        tabContainerView.addSubviews(
            sentRequestButton, receivedRequestButton,
            bottomDividerView, sentRequestIndicatorView,
            receivedRequestIndicatorView
        )
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }

        tabContainerView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(64)
        }

        sentRequestButton.snp.makeConstraints {
            $0.leading.top.equalToSuperview()

            $0.bottom.equalTo(bottomDividerView.snp.top).offset(9)

            $0.width.equalToSuperview().multipliedBy(0.5)
        }

        receivedRequestButton.snp.makeConstraints {
            $0.trailing.top.equalToSuperview()

            $0.bottom.equalTo(bottomDividerView.snp.top).offset(9)

            $0.width.equalToSuperview().multipliedBy(0.5)
        }

        bottomDividerView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }

        sentRequestIndicatorView.snp.makeConstraints {
            $0.leading.equalTo(sentRequestButton.snp.leading).offset(20)

            $0.trailing.equalTo(sentRequestButton.snp.trailing)

            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }

        receivedRequestIndicatorView.snp.makeConstraints {
            $0.leading.equalTo(receivedRequestButton.snp.leading)

            $0.trailing.equalTo(receivedRequestButton.snp.trailing).inset(20)

            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }

        requestTableView.snp.makeConstraints {
            $0.top.equalTo(tabContainerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }

    override func registerCells() {
        requestTableView.register(
            AlarmRequestTableViewCell.self,
            forCellReuseIdentifier:
                AlarmRequestTableViewCell.identifier
        )
    }

    // MARK: - Methods

    func updateSelectedTab(_ tab: AlarmTab) {
        switch tab {
        case .sent:
            sentRequestButton.setTitleColor(.grey80, for: .normal)

            receivedRequestButton.setTitleColor(.grey40, for: .normal)

            sentRequestIndicatorView.isHidden = false
            receivedRequestIndicatorView.isHidden = true

        case .received:
            sentRequestButton.setTitleColor(.grey40, for: .normal)

            receivedRequestButton.setTitleColor(.grey80, for: .normal)

            sentRequestIndicatorView.isHidden = true
            receivedRequestIndicatorView.isHidden = false
        }
    }

    func scrollToTop() {
        requestTableView.setContentOffset(
            CGPoint(x: 0, y: -requestTableView.adjustedContentInset.top),
            animated: false
        )
    }
}
