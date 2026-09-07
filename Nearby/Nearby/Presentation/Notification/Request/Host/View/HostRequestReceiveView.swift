//
//  HostRequestReceiveView.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import UIKit

import Lottie
import SnapKit
import Then

final class HostRequestReceiveView: BaseView {
    
    // MARK: - Properties
    
    var onBackButtonDidTap: (() -> Void)?
    var onNextButtonDidTap: (() -> Void)?
    var onAllowButtonDidTap: (() -> Void)?
    var onRejectButtonDidTap: (() -> Void)?
    
    // MARK: - UI Components
    
    private let navigationBar = NearbyNavigationBar()
    
    private let titleView = UIView()
    private let animationView = LottieAnimationView(name: "RequestAccept")
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    private let applicantView = UIStackView()
    
    private let profileView = UIStackView()
    private let profileImageView = GradientCircleView(diameter: 65)
    
    private let labelStackView = UIStackView()
    
    private let profileInformationStackView = UIStackView()
    private let nameLabel = UILabel()
    private let genderLabel = UILabel()
    
    private let identificationView = UIView()
    private let identificationLabel = UILabel()
    private let levelLabel = UILabel()
    private let nextButton = UIButton()
    
    private let dividerView = UIView()
    
    private let informationView = UIStackView()
    
    private let locationStackView = UIStackView()
    private let locationImageView = UIImageView()
    private let locationLabel = UILabel()
    
    private let dateStackView = UIStackView()
    private let calendarImageView = UIImageView()
    private let dateLabel = UILabel()
    
    private let allowButton = NearbyButton(style: .allowed, title: "수락하기")
    private let rejectButton = NearbyButton(style: .rejected, title: "거절하기")
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        animationView.do {
            $0.backgroundColor = .clear
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .loop
            $0.backgroundBehavior = .pauseAndRestore
        }
        
        titleLabel.do {
            $0.setFont(.h2M22, text: "", textColor: .black)
            $0.textAlignment = .center
        }
        
        subTitleLabel.do {
            $0.setFont(.b2M16, text: "", textColor: .grey30)
        }
        
        applicantView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 16
            $0.axis = .vertical
            $0.spacing = 16
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        }
        
        profileView.do {
            $0.axis = .horizontal
            $0.spacing = 16
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
            $0.alignment = .leading
        }
        
        profileInformationStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
        
        nameLabel.do {
            $0.setFont(.h3Sb20, text: "", textColor: .black)
            $0.textAlignment = .left
        }
        
        genderLabel.do {
            $0.setFont(.b1M18, text: "", textColor: .primary50)
            $0.textAlignment = .left
        }
        
        identificationLabel.do {
            $0.setFont(.b3M14, text: "본인인증 완료 · 매너 지수", textColor: .grey60)
            $0.textAlignment = .left
        }
        
        levelLabel.do {
            $0.setFont(.b1Sb18, text: "", textColor: .primary50)
        }
        
        nextButton.do {
            $0.setImage(.chevronRightIcon, for: .normal)
        }
        
        informationView.do {
            $0.axis = .vertical
            $0.spacing = 10
        }
        
        dividerView.do {
            $0.backgroundColor = .grey10
        }
        
        locationStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
        
        locationImageView.do {
            $0.image = .smallLocationIcon
        }
        
        locationLabel.do {
            $0.setFont(.b2M16, text: "", textColor: .grey80)
            $0.textAlignment = .left
        }
        
        dateStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
        
        calendarImageView.do {
            $0.image = .calendarIcon
        }
        
        dateLabel.do {
            $0.setFont(.b2M16, text: "", textColor: .grey80)
            $0.textAlignment = .left
        }
        
        navigationBar.do {
            $0.configure(leftItem: .back, centerItem: .title("동행 신청"))
        }
    }
    
    override func setUI() {
        addSubviews(navigationBar, titleView, applicantView, rejectButton, allowButton)
        titleView.addSubviews(animationView, titleLabel, subTitleLabel)
        applicantView.addArrangedSubviews(profileView, dividerView, informationView)
        applicantView.setCustomSpacing(12, after: dividerView)
        profileView.addArrangedSubviews(profileImageView, labelStackView)
        labelStackView.addArrangedSubviews(profileInformationStackView, identificationView)
        profileInformationStackView.addArrangedSubviews(nameLabel, genderLabel)
        identificationView.addSubviews(identificationLabel, levelLabel, nextButton)
        informationView.addArrangedSubviews(locationStackView, dateStackView)
        locationStackView.addArrangedSubviews(locationImageView, locationLabel)
        dateStackView.addArrangedSubviews(calendarImageView, dateLabel)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(self.snp.centerY).multipliedBy(0.39)
            $0.horizontalEdges.equalToSuperview()
        }

        animationView.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.centerY).multipliedBy(1.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(300)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(animationView.snp.bottom).offset(-70)
            $0.centerX.equalToSuperview()
        }

        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        applicantView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        profileView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        
        identificationView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        identificationLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
        
        levelLabel.snp.makeConstraints {
            $0.leading.equalTo(identificationLabel.snp.trailing).offset(4)
        }
        
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.size.equalTo(25)
        }
        
        dividerView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        informationView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        locationImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        calendarImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        rejectButton.snp.makeConstraints {
            $0.width.equalTo(125)
            $0.height.equalTo(56)
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        allowButton.snp.makeConstraints {
            $0.width.equalTo(220)
            $0.height.equalTo(56)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(rejectButton.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    override func setAddTarget() {
        navigationBar.leftButtonAction = { [weak self] in
            self?.onBackButtonDidTap?()
        }
        nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        rejectButton.addTarget(self, action: #selector(rejectButtonDidTap), for: .touchUpInside)
        allowButton.addTarget(self, action: #selector(allowButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Methods
    
    func configure(with output: HostRequestReceiveViewModel.DisplayData) {
        nameLabel.text = output.name
        profileImageView.configure(imageUrl: output.profileImageUrl)
        genderLabel.text = output.gender
        levelLabel.text = output.level
        titleLabel.text = output.title
        subTitleLabel.text = output.subtitle
        locationLabel.text = output.location
        dateLabel.text = output.date
    }
    
    func restartAnimation() {
        animationView.stop()
        animationView.currentProgress = 0
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: .loop)
    }
    
    // MARK: - Actions
    
    @objc
    private func allowButtonDidTap() {
        onAllowButtonDidTap?()
    }
    
    @objc
    private func nextButtonDidTap() {
        onNextButtonDidTap?()
    }
    
    @objc
    private func rejectButtonDidTap() {
        onRejectButtonDidTap?()
    }
}
