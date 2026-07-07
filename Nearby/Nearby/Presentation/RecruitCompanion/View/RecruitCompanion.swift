//
//  RecruitCompanion.swift
//  Nearby
//
//  Created by 장지인 on 7/6/26.
//

import UIKit

import SnapKit
import Then

final class RecruitCompanionView: BaseView {
    
    // MARK: - UI Component

    private let whenTitleLabel = UILabel()
    private let nowButton = NearbyButton(style: .selected, title: "지금 바로")
    private let timeButton = NearbyButton(style: .unselected, title: "시간 설정")
    private let buttonStackView = UIStackView()
    private let dateOptionView = UIView()
    private let datePicker = NearbyDateTimePickerView()
    private let dateCheckBox = NearbyCheckBox(text: "동행과 정하고 싶어요")
    private let peopleStepper = NearbyStepper()
    private let peopleNumber = UILabel()
    private let peopleTitleLabel = UILabel()
    private let peopleCheckBox = NearbyCheckBox(text: "목표 인원이 안 차도 출발할래요")
    private let peopleButton = UIButton()
    private let peopleTopDivider = UIView()
    private let peopleBottomDivider = UIView()
    
    // MARK: - Properties

    private var peopleTitleTopFromButtonConstraint: Constraint?
    private var peopleTitleTopFromDatePickerConstraint: Constraint?
    private var peopleCheckBoxTopFromTitleConstraint: Constraint?
    private var peopleCheckBoxTopFromStepperConstraint: Constraint?
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .white

        whenTitleLabel.do {
            $0.text = "언제 만날 예정인가요?"
            $0.textColor = .grey80
            $0.font = NearbyFont.b1Sb18.font
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.distribution = .fillEqually
        }
        
        dateOptionView.isHidden = true
        
        peopleTitleLabel.do {
            $0.text = "최대 몇 명과 함께 갈까요?"
            $0.font = NearbyFont.b1Sb18.font
            $0.textColor = .grey80
        }
        
        peopleNumber.do {
            $0.text = "2명"
            $0.font = NearbyFont.h3Sb20.font
            $0.textColor = .primary50
        }

        peopleStepper.isHidden = true

        [peopleTopDivider, peopleBottomDivider].forEach {
            $0.backgroundColor = .grey5
        }
        
        peopleButton.setImage(.chevronDownIcon, for: .normal)
        peopleButton.setImage(.chevronUpIcon, for: .selected)
    }

    override func setUI() {
        addSubviews(
            whenTitleLabel,
            buttonStackView,
            dateOptionView,
            peopleTopDivider,
            peopleTitleLabel,
            peopleStepper,
            peopleNumber,
            peopleButton,
            peopleCheckBox,
            peopleBottomDivider
        )
        buttonStackView.addArrangedSubviews(nowButton, timeButton)
        dateOptionView.addSubviews(datePicker, dateCheckBox)
    }

    override func setLayout() {
        whenTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(whenTitleLabel.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(46)
        }

        dateOptionView.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview()
        }

        datePicker.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(138)
        }
        
        dateCheckBox.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom)
            $0.leading.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(44)
        }

        peopleTopDivider.snp.makeConstraints {
            $0.bottom.equalTo(peopleTitleLabel.snp.top).offset(-24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        peopleTitleLabel.snp.makeConstraints {
            peopleTitleTopFromButtonConstraint = $0.top.equalTo(buttonStackView.snp.bottom).offset(40).constraint
            peopleTitleTopFromDatePickerConstraint = $0.top.equalTo(dateOptionView.snp.bottom).offset(40).constraint
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        peopleTitleTopFromDatePickerConstraint?.deactivate()
        
        peopleNumber.snp.makeConstraints {
            $0.centerY.equalTo(peopleTitleLabel.snp.centerY)
            $0.trailing.equalTo(peopleButton.snp.leading).offset(-8)
        }

        peopleButton.snp.makeConstraints {
            $0.centerY.equalTo(peopleTitleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(24)
        }
        
        peopleStepper.snp.makeConstraints {
            $0.top.equalTo(peopleTitleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }

        peopleCheckBox.snp.makeConstraints {
            peopleCheckBoxTopFromTitleConstraint = $0.top.equalTo(peopleTitleLabel.snp.bottom).offset(18.5).constraint
            peopleCheckBoxTopFromStepperConstraint = $0.top.equalTo(peopleStepper.snp.bottom).offset(25.5).constraint
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(22)
        }

        peopleBottomDivider.snp.makeConstraints {
            $0.top.equalTo(peopleCheckBox.snp.bottom).offset(31)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }

        peopleCheckBoxTopFromStepperConstraint?.deactivate()
    }

    override func registerCells() {
        setAction()
    }

    // MARK: - Method
    
    private func setAction() {
        nowButton.addTarget(self, action: #selector(nowButtonDidTap), for: .touchUpInside)
        timeButton.addTarget(self, action: #selector(timeButtonDidTap), for: .touchUpInside)
        peopleButton.addTarget(self, action: #selector(peopleButtonDidTap), for: .touchUpInside)
        peopleStepper.countDidChange = { [weak self] count in
            self?.peopleNumber.text = "\(count + 1)명"
        }
    }
    
    // MARK: - Action

    @objc
    private func nowButtonDidTap() {
        nowButton.setSelected(true)
        timeButton.setSelected(false)
        dateOptionView.isHidden = true
        peopleTitleTopFromDatePickerConstraint?.deactivate()
        peopleTitleTopFromButtonConstraint?.activate()
    }

    @objc
    private func timeButtonDidTap() {
        nowButton.setSelected(false)
        timeButton.setSelected(true)
        dateOptionView.isHidden = false
        peopleTitleTopFromButtonConstraint?.deactivate()
        peopleTitleTopFromDatePickerConstraint?.activate()
    }

    @objc
    private func peopleButtonDidTap() {
        peopleButton.isSelected.toggle()
        peopleStepper.isHidden = !peopleButton.isSelected

        if peopleButton.isSelected {
            peopleCheckBoxTopFromTitleConstraint?.deactivate()
            peopleCheckBoxTopFromStepperConstraint?.activate()
        } else {
            peopleCheckBoxTopFromStepperConstraint?.deactivate()
            peopleCheckBoxTopFromTitleConstraint?.activate()
        }
    }
}
