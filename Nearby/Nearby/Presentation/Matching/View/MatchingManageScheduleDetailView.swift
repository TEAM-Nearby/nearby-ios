//
//  MatchingManageScheduleDetailView.swift
//  Nearby
//
//  Created by 장지인 on 7/9/26.
//

import UIKit

import SnapKit
import Then

final class MatchingManageScheduleDetailView: BaseView {

    // MARK: - Properties

    var backButtonAction: (() -> Void)?
    var alarmButtonAction: (() -> Void)?
    private var isDatePickerVisible = false

    // MARK: - UI Components

    private let navigationBar = NearbyNavigationBar()
    private let matchedCardView = MatchingMatchedCardCell(frame: .zero)
    private let dateAndTimeTitleLabel = UILabel()
    private let datePickerContainerView = UIView()
    private let datePicker = UIDatePicker()
    private let placeTitleLabel = UILabel()
    private let placeImageView = UIImageView()
    private let placeDetailLabel = UILabel()
    private let confirmExplainLabel = UILabel()
    private let confirmButton = NearbyButton(style: .primary, title: "일정 확정하기")
    private let dateAndTimeButton = NearbyButton(style: .unselected, title: "")
    private let dateAndTimeImageView = UIImageView()
    private let mapView = NearbyMapView()

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        navigationBar.do {
            $0.configure(leftItem: .back, centerItem: .title("상세 일정"), rightItems: [.alarm])
        }

        matchedCardView.do {
            $0.configure(
                content: MatchingMatchedCardContentModel(
                    profileImage: .imgProfileDefault, name: "정지영", participantCount: 2,
                    gender: "여성", uploadedTime: "15분 전 올림", place: "시우다드 콘달",
                    meetingTime: "오후 4:30", description: "오늘 저녁 바르셀로나에서 같이 타파스 드실 분 구해요!"
                ),
                state: .pending,
                displayMode: .scheduleDetail
            )
            $0.setNextButtonHidden(true)
        }

        dateAndTimeTitleLabel.do {
            $0.setFont(.b2Sb16, text: "날짜 및 시간", textColor: .grey80)
            $0.textAlignment = .left
        }

        dateAndTimeButton.do {
            $0.contentHorizontalAlignment = .left
        }

        dateAndTimeImageView.do {
            $0.image = .calenderIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .grey30
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = false
        }

        datePickerContainerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
            $0.isHidden = true
        }

        datePicker.do {
            $0.backgroundColor = .white
            $0.datePickerMode = .dateAndTime
            $0.preferredDatePickerStyle = .inline
            $0.minimumDate = Date()
            $0.locale = Locale(identifier: "ko_KR")
            $0.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            $0.tintColor = .btnPrimaryBg
        }

        placeTitleLabel.do {
            $0.setFont(.b2Sb16, text: "집합 위치", textColor: .grey80)
            $0.textAlignment = .left
        }

        placeImageView.do {
            $0.image = .smallLocationBlackIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .grey40
        }

        placeDetailLabel.do {
            $0.setFont(.b3M14, text: "Siutat condal, Rambla de Catalunya, 16", textColor: .grey30)
        }

        confirmExplainLabel.do {
            $0.setFont(.b3M14, text: "일정을 확정하면 동행에게 알림이 가요!", textColor: .grey30)
        }

        configureMapView()
        updateDateAndTimeButtonTitle()
    }

    override func setUI() {
        addSubviews(
            navigationBar, matchedCardView, dateAndTimeTitleLabel,
            dateAndTimeButton, dateAndTimeImageView, placeTitleLabel,
            placeImageView, placeDetailLabel, mapView,
            confirmExplainLabel, confirmButton, datePickerContainerView
        )
        datePickerContainerView.addSubview(datePicker)
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

        dateAndTimeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(matchedCardView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(22)
        }

        dateAndTimeButton.snp.makeConstraints {
            $0.top.equalTo(dateAndTimeTitleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }

        dateAndTimeImageView.snp.makeConstraints {
            $0.centerY.equalTo(dateAndTimeButton.snp.centerY)
            $0.trailing.equalTo(dateAndTimeButton).offset(-34)
            $0.size.equalTo(24)
        }

        datePickerContainerView.snp.makeConstraints {
            $0.top.equalTo(dateAndTimeButton.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(380)
        }

        datePicker.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        placeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(dateAndTimeButton.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        placeImageView.snp.makeConstraints {
            $0.top.equalTo(placeTitleLabel.snp.bottom).offset(11)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(16)
        }

        placeDetailLabel.snp.makeConstraints {
            $0.centerY.equalTo(placeImageView.snp.centerY).offset(-1)
            $0.leading.equalTo(placeImageView.snp.trailing).offset(8)
            $0.height.equalTo(20)
        }

        mapView.snp.makeConstraints {
            $0.top.equalTo(placeDetailLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(230)
        }

        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }

        confirmExplainLabel.snp.makeConstraints {
            $0.bottom.equalTo(confirmButton.snp.top).offset(-12)
            $0.centerX.equalToSuperview()
        }
    }

    override func setAddTarget() {
        navigationBar.leftButtonAction = { [weak self] in
            self?.backButtonDidTap()
        }
        navigationBar.rightFirstButtonAction = { [weak self] in
            self?.alarmButtonDidTap()
        }
        dateAndTimeButton.addTarget(self, action: #selector(dateAndTimeButtonDidTap), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(datePickerValueDidChange), for: .valueChanged)
        confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
    }

    // MARK: - Methods

    private func updateDateAndTimeButtonTitle() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd  HH:mm"

        applyDateAndTimeButtonTitle(title: formatter.string(from: datePicker.date))
    }

    private func applyDateAndTimeButtonTitle(title: String) {
        dateAndTimeButton.setPaddedTitle(
            title,
            font: .b2M16,
            titleColor: .btnPrimaryBg,
            titleInsets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        )
    }

    private func updateDatePickerVisibility() {
        datePickerContainerView.isHidden = !isDatePickerVisible
        bringSubviewToFront(datePickerContainerView)
    }

    private func configureMapView() {
        mapView.configure(latitude: 37.566508, longitude: 126.977945)
    }

    // MARK: - Actions

    private func backButtonDidTap() {
        backButtonAction?()
    }

    private func alarmButtonDidTap() {
        alarmButtonAction?()
    }

    @objc
    private func dateAndTimeButtonDidTap() {
        isDatePickerVisible.toggle()
        updateDatePickerVisibility()
    }

    @objc
    private func datePickerValueDidChange() {
        updateDateAndTimeButtonTitle()
    }

    @objc
    private func confirmButtonDidTap() {
        // TODO: - 일정 확정 API 연결
    }
}
