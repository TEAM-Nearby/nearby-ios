//
//  RecruitCompanion.swift
//  Nearby
//
//  Created by 장지인 on 7/6/26.
//

import UIKit

import SnapKit

final class RecruitCompanionView: BaseView {
    
    // MARK: - UI Component

    private let whenTitleLabel = UILabel()
    private let nowButton = NearbyButton(style: .selected, title: "지금 바로")
    private let timeButton = NearbyButton(style: .unselected, title: "시간 설정")
    private let buttonStackView = UIStackView()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .white

        whenTitleLabel.text = "언제 만날 예정인가요?"
        whenTitleLabel.textColor = .grey80
        whenTitleLabel.font = NearbyFont.b1Sb18.font
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 12
        buttonStackView.distribution = .fillEqually
    }

    override func setUI() {
        addSubview(whenTitleLabel)
        addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(nowButton)
        buttonStackView.addArrangedSubview(timeButton)
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
    }

    override func registerCells() {
        setAction()
    }

    private func setAction() {
        nowButton.addTarget(self, action: #selector(nowButtonDidTap), for: .touchUpInside)
        timeButton.addTarget(self, action: #selector(timeButtonDidTap), for: .touchUpInside)
    }

    // MARK: - Action

    @objc
    private func nowButtonDidTap() {
        nowButton.setSelected(true)
        timeButton.setSelected(false)
    }

    @objc
    private func timeButtonDidTap() {
        nowButton.setSelected(false)
        timeButton.setSelected(true)
    }
}
