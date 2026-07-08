//
//  MeetingProgressView.swift
//  Nearby
//
//  Created by h2e on 7/8/26.
//

import UIKit

import SnapKit
import Then

final class MeetingProgressView: BaseView {
    
    // MARK: - Properties
    
    var onBackButtonDidTap: (() -> Void)?
    var onReportButtonDidTap: (() -> Void)?
    var onVerifyButtonDidTap: (() -> Void)?
    
    // MARK: - UI Components
    
    private let navigationBar = NearbyNavigationBar()
    
    private let companionView = UIStackView()
    
    private let profileView = UIStackView()
    private let imageView = UIImageView()
    private let labelStackView = UIStackView()
    
    private let identificationView = UIView()
    private let nameLabel = UILabel()
    private let genderLabel = UILabel()
    
    private let informationLabel = UILabel()
    
    private let dividerView = UIView()
    
    private let progressView = UIStackView()
    
    private let stepStackView = UIStackView()
    private let stepLabel = UILabel()
    private let stepDescriptionLabel = UILabel()
    
    private let progressBarView = UIStackView()
    private let progressBar = UIImageView()
    
    private let progressLabelStackView = UIStackView()
    private let matchingLabel = UILabel()
    private let verificationLabel = UILabel()
    private let completionLabel = UILabel()
    
    private let descriptionLabel = UILabel()
    private let verifyButton = NearbyButton(style: .primary, title: "만남 인증하기")
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        navigationBar.do {
            $0.configure(leftItem: .back, centerItem: .title("진행 중인 동행"), rightItems: [.report])
        }
        
        companionView.do {
            $0.axis = .vertical
            $0.spacing = 16
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 16
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        }
        
        profileView.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
        
        imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
            $0.alignment = .leading
        }
        
        nameLabel.do {
            $0.setFont(.b2Sb16, text: "", textColor: .grey80)
        }
        
        genderLabel.do {
            $0.setFont(.b2M16, text: "", textColor: .btnPrimaryBg)
        }
        
        informationLabel.do {
            $0.setFont(.b3M14, text: "", textColor: .grey80)
        }
        
        dividerView.do {
            $0.backgroundColor = .grey10
        }
        
        progressView.do {
            $0.axis = .vertical
            $0.spacing = 4
        }
        
        progressBarView.do {
            $0.alignment = .center
        }
        
        stepStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .leading
        }
        
        stepLabel.do {
            $0.backgroundColor = .primary20
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.setFont(.b2Sb16, text: "", textColor: .primary50)
            $0.textAlignment = .center
        }
        
        stepDescriptionLabel.do {
            $0.setFont(.b2Sb16, text: "", textColor: .grey80)
        }
        
        progressBarView.do {
            $0.axis = .vertical
            $0.spacing = 4
        }
        
        progressLabelStackView.do {
            $0.axis = .horizontal
            $0.spacing = 54
        }
        
        matchingLabel.do {
            $0.setFont(.b3M14, text: "매칭 완료", textColor: .grey40)
        }
        
        verificationLabel.do {
            $0.setFont(.b3M14, text: "만남 인증", textColor: .grey40)
        }
        
        completionLabel.do {
            $0.setFont(.b3M14, text: "동행 완료", textColor: .grey40)
        }
        
        descriptionLabel.do {
            $0.setFont(.b3M14, text: "약속 시간 1시간 전부터 만남을 인증할 수 있어요", textColor: .grey30)
        }
    }
    
    override func setUI() {
        addSubviews(navigationBar, companionView, descriptionLabel, verifyButton)
        companionView.addArrangedSubviews(profileView, dividerView, progressView)
        profileView.addArrangedSubviews(imageView, labelStackView)
        labelStackView.addArrangedSubviews(identificationView, informationLabel)
        identificationView.addSubviews(nameLabel, genderLabel)
        progressView.addArrangedSubviews(stepStackView, progressBarView)
        stepStackView.addArrangedSubviews(stepLabel, stepDescriptionLabel)
        progressBarView.addArrangedSubviews(progressBar, progressLabelStackView)
        progressLabelStackView.addArrangedSubviews(matchingLabel, verificationLabel, completionLabel)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        companionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        
        dividerView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        
        genderLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel.snp.centerY)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(8)
        }
        
        stepLabel.snp.makeConstraints {
            $0.width.equalTo(38)
            $0.height.equalTo(30)
        }
        
        stepDescriptionLabel.snp.makeConstraints {
            $0.centerY.equalTo(stepLabel.snp.centerY)
        }
        
        verifyButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.bottom.equalTo(verifyButton.snp.top).offset(-12)
            $0.centerX.equalToSuperview()
        }
        
        progressLabelStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
    }
    
    override func setAddTarget() {
        navigationBar.leftButtonAction = { [weak self] in
            self?.onBackButtonDidTap?()
        }
        navigationBar.rightFirstButtonAction = { [weak self] in
            self?.onReportButtonDidTap?()
        }
        verifyButton.addTarget(self, action: #selector(verifyButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Methods
    
    func configure(with data: MeetingProgressViewModel.DisplayData) {
        imageView.image = data.image
        nameLabel.text = data.name
        genderLabel.text = data.gender
        informationLabel.text = data.information
    }
    
    func updateStep(_ step: MeetingStep) {
        stepLabel.text = step.stepTitle
        stepDescriptionLabel.text = step.stepDescription
        progressBar.image = step.progressBarImage
    }
    
    func updateVerifyButtonState(_ state: MeetingProgressViewModel.VerifyButtonState) {
        verifyButton.isEnabled = state.isEnabled
        verifyButton.setTitle(state.title, for: .normal)
        descriptionLabel.isHidden = state.isDescriptionHidden
    }
    
    // MARK: - Action

    @objc
    private func verifyButtonDidTap() {
        onVerifyButtonDidTap?()
    }
}
