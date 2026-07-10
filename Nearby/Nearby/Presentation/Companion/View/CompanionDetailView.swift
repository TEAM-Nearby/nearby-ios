//
//  CompanionDetailView.swift
//  Nearby
//
//  Created by soomin on 7/10/26.
//

import UIKit
import SnapKit

final class CompanionDetailView: BaseView {

    // MARK: - Properties

    var onBackButtonDidTap: (() -> Void)?
    var onApplyButtonDidTap: (() -> Void)?

    // MARK: - UI Components

    private let backButton = UIButton()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let topView = CompanionDetailTopView()
    private let bottomView = CompanionDetailBottomView()
    private let buttonContainerView = UIView()
    private let applyCompanionButton = NearbyButton(style: .primary, title: "동행 신청하기")

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .bgDefaultGrey

        backButton.setImage(.chevronLeftIcon, for: .normal)
        backButton.tintColor = .grey80

        scrollView.backgroundColor = .bgDefaultGrey
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self

        buttonContainerView.backgroundColor = .white
    }

    override func setUI() {
        addSubviews(backButton, scrollView, buttonContainerView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(topView, bottomView)
        buttonContainerView.addSubview(applyCompanionButton)
    }

    override func setLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(2)
            $0.leading.equalToSuperview().inset(8)
            $0.size.equalTo(44)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(buttonContainerView.snp.top)
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

        buttonContainerView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        applyCompanionButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

    override func setAddTarget() {
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        applyCompanionButton.addTarget(self, action: #selector(applyButtonDidTap), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc
    private func backButtonDidTap() {
        onBackButtonDidTap?()
    }

    @objc
    private func applyButtonDidTap() {
        onApplyButtonDidTap?()
    }

    // MARK: - Method

    func configure(state: CompanionDetailState) {
        applyCompanionButton.setEnabled(state.isApplicationEnabled)
        bottomView.configure(postType: state.postType)
    }
}

// MARK: - UIScrollViewDelegate

extension CompanionDetailView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maximumOffsetY = max(-scrollView.adjustedContentInset.top, scrollView.contentSize.height
                                  - scrollView.bounds.height + scrollView.adjustedContentInset.bottom)

        scrollView.backgroundColor = scrollView.contentOffset.y >= maximumOffsetY ? .white : .bgDefaultGrey
    }
}
