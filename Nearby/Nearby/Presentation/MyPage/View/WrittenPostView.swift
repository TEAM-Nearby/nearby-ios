//
//  WrittenPostView.swift
//  Nearby
//
//  Created by 신서연 on 7/11/26.
//

import UIKit

import SnapKit
import Then

final class WrittenPostView: BaseView {

    // MARK: - UI Components

    let navigationBar = NearbyNavigationBar()

    let tableView = UITableView(frame: .zero, style: .plain)

    let findCompanionButton = NearbyButton(style: .primary, title: "내 주변의 동행 찾아보기")

    private let emptyView = WrittenPostEmptyView()
    private let bottomButtonContainerView = UIView()

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        navigationBar.do {
            $0.configure(leftItem: .back, centerItem: .title("내가 작성한 모집글"))
        }

        tableView.do {
            $0.backgroundColor = .white
            $0.separatorStyle = .none

            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = true

            $0.rowHeight = UITableView.automaticDimension

            $0.estimatedRowHeight = 600

            $0.contentInset = .zero

            $0.scrollIndicatorInsets = .zero

            $0.contentInsetAdjustmentBehavior = .never

            $0.isHidden = true
        }

        emptyView.do {
            $0.isHidden = false
        }

        bottomButtonContainerView.do {
            $0.backgroundColor = .white
        }
    }

    override func setUI() {
        addSubviews(navigationBar, tableView, emptyView, bottomButtonContainerView)

        bottomButtonContainerView.addSubview(findCompanionButton)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }

        bottomButtonContainerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        findCompanionButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        emptyView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bottomButtonContainerView.snp.top)
        }
    }

    override func registerCells() {
        tableView.register(
            WrittenPostTableViewCell.self,
            forCellReuseIdentifier: WrittenPostTableViewCell.identifier
        )
    }

    // MARK: - Method

    func updateContent(items: [WrittenPostItem]) {
        let isEmpty = items.isEmpty

        emptyView.isHidden = !isEmpty
        tableView.isHidden = isEmpty

        bottomButtonContainerView.isHidden = !isEmpty

        if isEmpty {
            emptyView.playAnimationIfNeeded()
        } else {
            emptyView.stopAnimation()
        }
    }

    func playEmptyAnimationIfNeeded() {
        guard !emptyView.isHidden else { return }
        emptyView.playAnimationIfNeeded()
    }
}
