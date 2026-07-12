//
//  MatchingScheduleDetailView.swift
//  Nearby
//
//  Created by 장지인 on 7/10/26.
//

import UIKit

import SnapKit
import Then

final class MatchingScheduleDetailView: BaseView {
    
    // MARK: - Properties
    
    var backButtonAction: (() -> Void)?
    var alarmButtonAction: (() -> Void)?
    var editButtonAction: (() -> Void)?
    var shareButtonAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private let navigationBar = NearbyNavigationBar()
    private let matchedCardView = MatchingMatchedCardCell(frame: .zero)
    private let placeImageView = UIImageView()
    private let placeTitleLabel = UILabel()
    private let placeNameLabel = UILabel()
    private let placeDetailLabel = UILabel()
    private let placeCopyButton = UIButton()
    private let mapView = NearbyMapView()
    private let dateAndTimeImageView = UIImageView()
    private let dateAndTimeTitleLabel = UILabel()
    private let dateAndTimeDetailLabel = UILabel()
    private let dateDividerView = UIView()
    private let kakaoLinkImageView = UIImageView()
    private let kakaoLinkTitleLabel = UILabel()
    private let kakaoLinkDetailLabel = UILabel()
    private let kakaoLinkCopyButton = UIButton()
    private let bottomButtonStackView = UIStackView()
    private let manageButton = NearbyButton(style: .rejected, title: "수정하기")
    private let shareButton = NearbyButton(style: .primary, title: "공유하기")
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .white
        
        navigationBar.do {
            $0.configure(leftItem: .back, centerItem: .title("상세 일정"), rightItems: [.alarm])
        }
        
        matchedCardView.do {
            $0.setNextButtonHidden(true)
        }
        
        
        bottomButtonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fill
        }
        
        placeImageView.do {
            $0.image = .loaction.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .btnPrimaryBg
        }
        
        placeTitleLabel.do {
            $0.setFont(.b3M14, text: "장소", textColor: .grey50)
            $0.textAlignment = .left
        }
        
        placeNameLabel.do {
            $0.setFont(.b2M16, textColor: .grey80)
        }
        
        placeDetailLabel.do {
            $0.setFont(.b3M14, textColor: .grey30)
        }
        
        placeCopyButton.do {
            $0.setImage(.copyIcon.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .grey30
        }
        
        dateAndTimeImageView.do {
            $0.image = .smallCalenderIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .btnPrimaryBg
        }
        
        dateAndTimeTitleLabel.do {
            $0.setFont(.b3M14, text: "날짜 및 시간", textColor: .grey50)
            $0.textAlignment = .left
        }
        
        dateAndTimeDetailLabel.do {
            $0.setFont(.b2M16, textColor: .grey80)
        }
        
        dateDividerView.do {
            $0.backgroundColor = .grey5
        }
        
        kakaoLinkImageView.do {
            $0.image = .chatIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .btnPrimaryBg
        }
        
        kakaoLinkTitleLabel.do {
            $0.setFont(.b3M14, text: "카카오톡 url", textColor: .grey50)
            $0.textAlignment = .left
        }
        
        kakaoLinkDetailLabel.do {
            $0.setFont(.b2M16, textColor: .grey80)
        }
        
        kakaoLinkCopyButton.do {
            $0.setImage(.copyIcon.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .grey30
        }
        
        bottomButtonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fill
        }
    }
    
    override func setUI() {
        addSubviews(
            navigationBar, matchedCardView,
            placeImageView, placeTitleLabel, placeNameLabel,
            placeDetailLabel, placeCopyButton, mapView,
            dateAndTimeImageView, dateAndTimeTitleLabel,
            dateAndTimeDetailLabel, dateDividerView,
            kakaoLinkImageView, kakaoLinkTitleLabel,
            kakaoLinkDetailLabel, kakaoLinkCopyButton,
            bottomButtonStackView
        )
        bottomButtonStackView.addArrangedSubviews(manageButton, shareButton)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        matchedCardView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(110)
        }
        
        placeImageView.snp.makeConstraints {
            $0.top.equalTo(matchedCardView.snp.bottom).offset(28)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(16)
        }
        
        placeTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(placeImageView.snp.centerY)
            $0.leading.equalTo(placeImageView.snp.trailing).offset(4)
            $0.height.equalTo(20)
        }
        
        placeNameLabel.snp.makeConstraints {
            $0.top.equalTo(placeTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(40)
            $0.height.equalTo(22)
        }
        
        placeDetailLabel.snp.makeConstraints {
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(placeNameLabel.snp.leading)
            $0.trailing.lessThanOrEqualTo(placeCopyButton.snp.leading).offset(-8)
            $0.height.equalTo(20)
        }
        
        placeCopyButton.snp.makeConstraints {
            $0.centerY.equalTo(placeDetailLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(24)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(placeDetailLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(143)
        }
        
        dateAndTimeImageView.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(36)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(16)
        }
        
        dateAndTimeTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateAndTimeImageView.snp.centerY)
            $0.leading.equalTo(dateAndTimeImageView.snp.trailing).offset(4)
            $0.height.equalTo(20)
        }
        
        dateAndTimeDetailLabel.snp.makeConstraints {
            $0.top.equalTo(dateAndTimeTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(40)
            $0.height.equalTo(22)
        }
        
        dateDividerView.snp.makeConstraints {
            $0.top.equalTo(dateAndTimeDetailLabel.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        kakaoLinkImageView.snp.makeConstraints {
            $0.top.equalTo(dateDividerView.snp.bottom).offset(18)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(16)
        }
        
        kakaoLinkTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(kakaoLinkImageView.snp.centerY)
            $0.leading.equalTo(kakaoLinkImageView.snp.trailing).offset(4)
            $0.height.equalTo(20)
        }
        
        kakaoLinkDetailLabel.snp.makeConstraints {
            $0.top.equalTo(kakaoLinkTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(40)
            $0.trailing.lessThanOrEqualTo(kakaoLinkCopyButton.snp.leading).offset(-8)
            $0.height.equalTo(22)
        }
        
        kakaoLinkCopyButton.snp.makeConstraints {
            $0.centerY.equalTo(kakaoLinkDetailLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(24)
        }
        
        bottomButtonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(23)
            $0.height.equalTo(56)
        }
        
        manageButton.snp.makeConstraints {
            $0.width.equalTo(126)
        }
    }
    
    override func setAddTarget() {
        navigationBar.leftButtonAction = { [weak self] in
            self?.backButtonDidTap()
        }
        navigationBar.rightFirstButtonAction = { [weak self] in
            self?.alarmButtonDidTap()
        }
        placeCopyButton.addTarget(self, action: #selector(placeCopyButtonDidTap), for: .touchUpInside)
        kakaoLinkCopyButton.addTarget(self, action: #selector(kakaoLinkCopyButtonDidTap), for: .touchUpInside)
        manageButton.addTarget(self, action: #selector(manageButtonDidTap), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonDidTap), for: .touchUpInside)
    }
}

// MARK: - Methods

extension MatchingScheduleDetailView {
    func configure(displayData: MatchingScheduleDetailDisplayData) {
        matchedCardView.configure(
            content: displayData.cardItem.content,
            displayMode: .scheduleDetail
        )
        matchedCardView.setNextButtonHidden(true)
        placeNameLabel.setFont(.b2M16, text: displayData.placeName, textColor: .grey80)
        placeDetailLabel.setFont(.b3M14, text: displayData.placeAddress, textColor: .grey30)
        dateAndTimeDetailLabel.setFont(.b2M16, text: displayData.scheduledAtText, textColor: .grey80)
        kakaoLinkDetailLabel.setFont(.b2M16, text: displayData.openChatUrl, textColor: .grey80)
        mapView.configure(latitude: displayData.latitude, longitude: displayData.longitude)
        configure(type: displayData.type)
    }
    
    private func configure(type: NearbyUserType) {
        if type == .host {
            guard manageButton.superview == nil else { return }
            bottomButtonStackView.insertArrangedSubview(manageButton, at: 0)
        } else {
            bottomButtonStackView.removeArrangedSubview(manageButton)
            manageButton.removeFromSuperview()
        }
    }
    
    // MARK: - Actions
    
    private func backButtonDidTap() {
        backButtonAction?()
    }
    
    private func alarmButtonDidTap() {
        alarmButtonAction?()
    }
    
    @objc
    private func placeCopyButtonDidTap() {
        UIPasteboard.general.string = placeDetailLabel.text
    }
    
    @objc
    private func kakaoLinkCopyButtonDidTap() {
        UIPasteboard.general.string = kakaoLinkDetailLabel.text
    }
    
    @objc
    private func manageButtonDidTap() {
        editButtonAction?()
    }
    
    @objc
    private func shareButtonDidTap() {
        shareButtonAction?()
    }
}
