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
    private let meetingPlaceTextView = NearbyTextView(placeholder: "장소를 입력해주세요")
    private let descriptionTitleLabel = UILabel()
    private let descriptionTextView = NearbyTextView(
        placeholder: "ex) 20대 여자입니다. 맛집 탐방하는 걸 좋아해요 :)\n"
            + "사진 잘 찍어드릴 수 있습니다!\n"
            + "같이 재미있게 놀아요..."
    )
    private let kakaoLinkTitleLabel = UILabel()
    private let kakaoLinkTextView = NearbyTextView(placeholder: "오픈채팅방 링크(URL)를 입력해주세요")
    private let kakaoLinkErrorLabel = UILabel()
    private let completeButton = NearbyButton(style: .primary, title: "작성 완료하기")
    private let placeSearchResultTableView = UITableView()

    // MARK: - Properties

    private var placeSearchResultTableViewHeightConstraint: Constraint?
    private var descriptionTextViewHeightConstraint: Constraint?
    private var descriptionTextViewMinimumHeight: CGFloat {
        return ceil(NearbyFont.b3M14.property.lineHeight * 3) + 32
    }
    private var placeSuggestions: [PlaceSearchResultItem] = []

    var placeDidSelect: ((PlaceSearchResultItem) -> Void)?
    var placeSearchButtonAction: (() -> Void)?
    var placeQueryDidChange: ((String) -> Void)?
    var contentDidChange: ((String) -> Void)?
    var openChatURLDidChange: ((String) -> Void)?
    var completeButtonAction: (() -> Void)?

    // MARK: - Custom Methods

    override func setStyle() {
        meetingPlaceTitleLabel.do {
            $0.setFont(.b1Sb18, text: "어디서 만날까요?")
        }

        meetingPlaceTextView.do {
            $0.updatePlaceholder(isHidden: false)
            $0.clearButton.setImage(.searchIcon, for: .normal)
            $0.clearButton.tintColor = .grey40
            $0.isClearButtonHidden = false
            $0.setPlaceholderTruncation(numberOfLines: 1)
            $0.verticallyCentersSingleLineText = true
            $0.textView.isScrollEnabled = false
        }

        descriptionTitleLabel.do {
            $0.setFont(.b1Sb18, text: "나이와 간단한 소개를 적어볼까요?")
        }

        descriptionTextView.do {
            $0.updatePlaceholder(isHidden: false)
            $0.isClearButtonHidden = true
            $0.setPlaceholderTruncation(numberOfLines: 3)
            $0.textView.isScrollEnabled = false
        }

        kakaoLinkTitleLabel.do {
            $0.setFont(.b1Sb18, text: "카카오톡 오픈채팅 링크")
        }

        kakaoLinkTextView.do {
            $0.updatePlaceholder(isHidden: false)
            $0.isClearButtonHidden = true
            $0.setPlaceholderTruncation(numberOfLines: 1)
            $0.verticallyCentersSingleLineText = true
        }

        kakaoLinkErrorLabel.do {
            $0.setFont(.b3R14, text: "오픈채팅방 링크(URL)만 입력해 주세요", textColor: .highlightRed)
            $0.isHidden = true
        }

        placeSearchResultTableView.do {
            $0.backgroundColor = .white
            $0.separatorStyle = .singleLine
            $0.layer.cornerRadius = 8
            $0.isHidden = true
            $0.rowHeight = 60
        }

        completeButton.setEnabled(false)
    }

    override func setUI() {
        addSubviews(
            meetingPlaceTitleLabel, meetingPlaceTextView,
            descriptionTitleLabel, descriptionTextView,
            kakaoLinkTitleLabel, kakaoLinkTextView, kakaoLinkErrorLabel,
            completeButton, placeSearchResultTableView
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
            descriptionTextViewHeightConstraint = $0.height.equalTo(descriptionTextViewMinimumHeight).constraint
        }

        placeSearchResultTableView.snp.makeConstraints {
            $0.top.equalTo(meetingPlaceTextView.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(20)
            placeSearchResultTableViewHeightConstraint = $0.height.equalTo(0).constraint
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

        kakaoLinkErrorLabel.snp.makeConstraints {
            $0.top.equalTo(kakaoLinkTextView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        completeButton.snp.makeConstraints {
            $0.top.equalTo(kakaoLinkErrorLabel.snp.bottom).offset(20)
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
        placeSearchResultTableView.dataSource = self
        placeSearchResultTableView.delegate = self
        placeSearchResultTableView.register(PlaceSearchResultCell.self)
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

    func update(state: RecruitCompanionViewModel.State) {
        if meetingPlaceTextView.textView.text != state.placeQuery {
            meetingPlaceTextView.textView.text = state.placeQuery
        }
        meetingPlaceTextView.updatePlaceholder(isHidden: !state.placeQuery.isEmpty)
        kakaoLinkErrorLabel.isHidden = !state.shouldShowOpenChatURLError
        completeButton.setEnabled(state.isCompleteButtonEnabled)
    }

    func updatePlaceSuggestions(_ suggestions: [PlaceSearchResultItem]) {
        placeSuggestions = suggestions
        let placeSuggestionCount = suggestions.count
        let tableViewHeight = min(CGFloat(placeSuggestionCount) * 60, 300)
        placeSearchResultTableView.isHidden = placeSuggestionCount == 0
        placeSearchResultTableViewHeightConstraint?.update(
            offset: tableViewHeight
        )
        placeSearchResultTableView.reloadData()
        UIView.performWithoutAnimation {
            layoutIfNeeded()
        }
    }

    func updateSelectedPlace(_ placeName: String) {
        meetingPlaceTextView.textView.text = placeName
        meetingPlaceTextView.updatePlaceholder(isHidden: true)
        placeSuggestions = []
        placeSearchResultTableView.isHidden = true
        placeSearchResultTableViewHeightConstraint?.update(offset: 0)
        placeSearchResultTableView.reloadData()
        UIView.performWithoutAnimation {
            layoutIfNeeded()
        }
        meetingPlaceTextView.textView.resignFirstResponder()
    }

    func focusedInputVisibleRect() -> CGRect? {
        if kakaoLinkTextView.textView.isFirstResponder {
            let inputRect = kakaoLinkTextView.convert(kakaoLinkTextView.bounds, to: self)
            let buttonRect = completeButton.convert(completeButton.bounds, to: self)
            return inputRect.union(buttonRect).insetBy(dx: 0, dy: -16)
        }

        if descriptionTextView.textView.isFirstResponder {
            return descriptionTextView.convert(descriptionTextView.bounds, to: self).insetBy(dx: 0, dy: -16)
        }

        if meetingPlaceTextView.textView.isFirstResponder {
            return meetingPlaceTextView.convert(meetingPlaceTextView.bounds, to: self).insetBy(dx: 0, dy: -16)
        }

        return nil
    }

    // MARK: - Actions

    @objc
    private func searchButtonDidTap() {
        placeSearchButtonAction?()
    }

    @objc
    private func completeButtonDidTap() {
        completeButtonAction?()
    }
}

// MARK: - UITextViewDelegate

extension RecruitCompanionBottomView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let shouldHidePlaceholder = !textView.text.isEmpty

        if textView == meetingPlaceTextView.textView {
            meetingPlaceTextView.updatePlaceholder(isHidden: shouldHidePlaceholder)
            placeQueryDidChange?(textView.text)
        } else if textView == descriptionTextView.textView {
            descriptionTextView.updatePlaceholder(isHidden: shouldHidePlaceholder)
            updateDescriptionTextViewHeight()
            contentDidChange?(textView.text)
        } else if textView == kakaoLinkTextView.textView {
            kakaoLinkTextView.updatePlaceholder(isHidden: shouldHidePlaceholder)
            openChatURLDidChange?(textView.text)
        }
    }
}

// MARK: - UITableViewDataSource

extension RecruitCompanionBottomView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeSuggestions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(PlaceSearchResultCell.self, for: indexPath)
        cell.configure(with: placeSuggestions[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension RecruitCompanionBottomView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSuggestion = placeSuggestions[indexPath.row]
        updateSelectedPlace(selectedSuggestion.name)
        placeDidSelect?(selectedSuggestion)
    }
}
