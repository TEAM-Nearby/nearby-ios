//
//  RecruitCompanionView.swift
//  Nearby
//
//  Created by 장지인 on 7/6/26.
//

import UIKit

import SnapKit
import Then

final class RecruitCompanionView: BaseView {
    
    // MARK: - UI Components

    private let navigationBar = NearbyNavigationBar()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let topView = RecruitCompanionTopView()
    private let bottomView = RecruitCompanionBottomView()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .white

        navigationBar.do{
            $0.configure(leftItem: .back, centerItem: .title("동행 모집하기"))
        }

        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
    }

    override func setUI() {
        addSubviews(navigationBar, scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(topView, bottomView)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

        topView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }

        bottomView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
