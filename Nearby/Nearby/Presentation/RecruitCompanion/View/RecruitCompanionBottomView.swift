//
//  RecruitCompanionBottomView.swift
//  Nearby
//
//  Created by 장지인 on 7/10/26.
//

import UIKit

import SnapKit
import Then

final class RecruitCompanionBottomView: BaseView {
    
    // MARK: - UI Components

    private let meetingPlaceTitleLabel = UILabel()
    private let meetingPlaceTextView = NearbyTextView(
        placeholder: "입력창입력창입력창입력창입력창입력창입력창..."
    )
    private let descriptionTitleLabel = UILabel()
    private let descriptionTextView = NearbyTextView(
        placeholder: "ex) 20대 여자입니다. 맛집 탐방하는 걸 좋아해요 :)\n"
            + "사진 잘 찍어드릴 수 있습니다!\n"
            + "같이 재미있게 놀아요..."
    )
    private let kakaoLinkTitleLabel = UILabel()
    private let kakaoLinkTextView = NearbyTextView(placeholder: "오픈채팅방 링크(URL)를 입력해 주세요")
    private let completeButton = NearbyButton(style: .primary, title: "작성 완료하기")
    
    // MARK: - Properties

    private var descriptionTextViewHeightConstraint: Constraint?
    private var descriptionTextViewMinimumHeight: CGFloat {
        return ceil(NearbyFont.b3M14.font.lineHeight * 3) + 32
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        meetingPlaceTitleLabel.do {
            $0.setFont(.b1Sb18, text: "어디서 만날까요?")
        }
        
        meetingPlaceTextView.do {
            $0.updatePlaceholder(isHidden: false)
            $0.clearButton.setImage(.searchIcon, for: .normal)
            $0.clearButton.tintColor = .grey40
            $0.clearButton.isHidden = false
            $0.setPlaceholderTruncation(numberOfLines: 1)
            $0.textView.isScrollEnabled = false
        }
        
        descriptionTitleLabel.do {
            $0.setFont(.b1Sb18, text: "나이와 간단한 소개를 적어볼까요?")
        }
        
        descriptionTextView.do {
            $0.updatePlaceholder(isHidden: false)
            $0.clearButton.isHidden = true
            $0.setPlaceholderTruncation(numberOfLines: 3)
            $0.textView.isScrollEnabled = false
        }
        
        kakaoLinkTitleLabel.do {
            $0.setFont(.b1Sb18, text: "카카오톡 오픈채팅 링크")
        }
        
        kakaoLinkTextView.do {
            $0.updatePlaceholder(isHidden: false)
            $0.clearButton.isHidden = true
            $0.setPlaceholderTruncation(numberOfLines: 1)
        }

        updateCompleteButtonState()
    }

    override func setUI() {
        addSubviews(
            meetingPlaceTitleLabel, meetingPlaceTextView,
            descriptionTitleLabel, descriptionTextView,
            kakaoLinkTitleLabel, kakaoLinkTextView,
            completeButton
        )
    }

    override func setLayout() {
        meetingPlaceTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        meetingPlaceTextView.snp.makeConstraints {
            $0.top.equalTo(meetingPlaceTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        descriptionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(meetingPlaceTextView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(descriptionTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            descriptionTextViewHeightConstraint = $0.height
                .equalTo(descriptionTextViewMinimumHeight)
                .constraint
        }
        
        kakaoLinkTitleLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionTextView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        kakaoLinkTextView.snp.makeConstraints {
            $0.top.equalTo(kakaoLinkTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        completeButton.snp.makeConstraints {
            $0.top.equalTo(kakaoLinkTextView.snp.bottom).offset(28)
            $0.bottom.equalToSuperview().inset(21)
            $0.height.equalTo(56)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }

    override func setAddTarget() {
        meetingPlaceTextView.textView.delegate = self
        descriptionTextView.textView.delegate = self
        kakaoLinkTextView.textView.delegate = self
        meetingPlaceTextView.clearButton.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Methods

    private func updateDescriptionTextViewHeight() {
        let textView = descriptionTextView.textView
        let fittingSize = CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude)
        let textHeight = textView.sizeThatFits(fittingSize).height
        let containerHeight = max(descriptionTextViewMinimumHeight, ceil(textHeight) + 32)

        descriptionTextViewHeightConstraint?.update(offset: containerHeight)

        UIView.performWithoutAnimation {
            layoutIfNeeded()
        }
    }

    private func hasText(_ textView: NearbyTextView) -> Bool {
        let text = textView.textView.text ?? ""

        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func updateCompleteButtonState() {
        let isEnabled = hasText(meetingPlaceTextView)
            && hasText(descriptionTextView)
            && hasText(kakaoLinkTextView)

        completeButton.setEnabled(isEnabled)
    }
    
    // MARK: - Actions
    
    @objc
    private func searchButtonDidTap() {
        // TODO: - 장소 검색 API 연결
    }

    @objc
    private func completeButtonDidTap() {
        // TODO: - 다음 뷰 연결
    }
}

// MARK: - UITextViewDelegate

extension RecruitCompanionBottomView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let shouldHidePlaceholder = !textView.text.isEmpty

        if textView == meetingPlaceTextView.textView {
            meetingPlaceTextView.updatePlaceholder(isHidden: shouldHidePlaceholder)
        } else if textView == descriptionTextView.textView {
            descriptionTextView.updatePlaceholder(isHidden: shouldHidePlaceholder)
            updateDescriptionTextViewHeight()
        } else if textView == kakaoLinkTextView.textView {
            kakaoLinkTextView.updatePlaceholder(isHidden: shouldHidePlaceholder)
        }

        updateCompleteButtonState()
    }
}
