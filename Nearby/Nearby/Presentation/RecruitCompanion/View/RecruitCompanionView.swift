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

    // MARK: - Properties

    var backButtonAction: (() -> Void)?
    var timeTypeDidSelect: ((RecruitMeetingTimeType) -> Void)?
    var meetingAtDidChange: ((Date) -> Void)?
    var participantCountDidChange: ((Int) -> Void)?
    var styleKeywordDidTap: ((String) -> Void)?
    var placeSearchButtonAction: (() -> Void)?
    var placeQueryDidChange: ((String) -> Void)?
    var contentDidChange: ((String) -> Void)?
    var openChatURLDidChange: ((String) -> Void)?
    var completeButtonAction: (() -> Void)?
    var placeDidSelect: ((SelectedPlace) -> Void)?

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        navigationBar.do {
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

    override func setAddTarget() {
        navigationBar.leftButtonAction = { [weak self] in
            self?.backButtonAction?()
        }
        topView.timeTypeDidSelect = { [weak self] type in
            self?.timeTypeDidSelect?(type)
        }
        topView.meetingAtDidChange = { [weak self] date in
            self?.meetingAtDidChange?(date)
        }
        topView.participantCountDidChange = { [weak self] count in
            self?.participantCountDidChange?(count)
        }
        topView.styleKeywordDidTap = { [weak self] keyword in
            self?.styleKeywordDidTap?(keyword)
        }
        bottomView.placeSearchButtonAction = { [weak self] in
            self?.placeSearchButtonAction?()
        }
        bottomView.placeQueryDidChange = { [weak self] query in
            self?.placeQueryDidChange?(query)
        }
        bottomView.contentDidChange = { [weak self] content in
            self?.contentDidChange?(content)
        }
        bottomView.openChatURLDidChange = { [weak self] url in
            self?.openChatURLDidChange?(url)
        }
        bottomView.completeButtonAction = { [weak self] in
            self?.completeButtonAction?()
        }
        bottomView.placeDidSelect = { [weak self] place in
            self?.placeDidSelect?(place)
        }
    }

    // MARK: - Method

    func update(state: RecruitCompanionViewModel.State) {
        topView.update(state: state)
        bottomView.update(state: state)
    }

    func updatePlaceSuggestions(_ suggestions: [PlaceSearchResultItem]) {
        bottomView.updatePlaceSuggestions(suggestions)
    }
}
