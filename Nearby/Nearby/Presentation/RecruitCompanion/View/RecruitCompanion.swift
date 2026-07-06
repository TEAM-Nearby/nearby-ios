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
    private let datePicker = NearbyDateTimePickerView()
    
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
        
        datePicker.isHidden = true
    }

    override func setUI() {
        addSubviews(whenTitleLabel, buttonStackView, datePicker)
        buttonStackView.addArrangedSubviews(nowButton, timeButton)
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

        datePicker.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(154)
        }
    }

    override func registerCells() {
        setAction()
    }

    // MARK: - Method
    
    private func setAction() {
        nowButton.addTarget(self, action: #selector(nowButtonDidTap), for: .touchUpInside)
        timeButton.addTarget(self, action: #selector(timeButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Action

    @objc
    private func nowButtonDidTap() {
        nowButton.setSelected(true)
        timeButton.setSelected(false)
        datePicker.isHidden = true
    }

    @objc
    private func timeButtonDidTap() {
        nowButton.setSelected(false)
        timeButton.setSelected(true)
        datePicker.isHidden = false
    }
    
}
