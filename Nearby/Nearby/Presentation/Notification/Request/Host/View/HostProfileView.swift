//
//  HostProfileView.swift
//  Nearby
//
//  Created by 신서연 on 7/12/26.
//

import UIKit

import SnapKit
import Then

final class HostProfileView: BaseView {

    // MARK: - Properties

    var onBackButtonDidTap: (() -> Void)?

    var onReviewChipDidTap: ((
        HostProfileReviewCategory,
        Int
    ) -> Void)?

    private var communicationChipButtons = [NearbyChipButton]()
    private var punctualityChipButtons = [NearbyChipButton]()

    // MARK: - UI Components

    private let navigationBar = NearbyNavigationBar()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let profileCardImageView = UIImageView()
    private let profileImageView = GradientCircleView(diameter: 80)

    private let nameStackView = UIStackView()
    private let nicknameLabel = UILabel()
    private let genderLabel = UILabel()

    private let verificationChip = NearbyChipButton(style: .badgeVerification, title: "본인인증 완료", horizontalInset: 22)

    private let personalityChipContainerView = UIView()
    private let personalityFirstLineStackView = UIStackView()
    private let personalitySecondLineStackView = UIStackView()

    private let mannerScoreCardView = UIView()
    private let mannerTitleLabel = UILabel()
    private let starRatingView = StarRatingView()

    private let introductionCardView = UIView()
    private let introductionTitleLabel = UILabel()
    private let introductionLabel = UILabel()

    private let reviewCardView = UIView()
    private let reviewTitleLabel = UILabel()

    private let communicationSectionView = UIView()
    private let communicationTitleLabel = UILabel()
    private let communicationChipContainerView = UIView()
    private let communicationFirstLineStackView = UIStackView()
    private let communicationSecondLineStackView = UIStackView()

    private let punctualitySectionView = UIView()
    private let punctualityTitleLabel = UILabel()
    private let punctualityChipContainerView = UIView()
    private let punctualityFirstLineStackView = UIStackView()
    private let punctualitySecondLineStackView = UIStackView()

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .bgDefaultGrey

        navigationBar.do {
            $0.backgroundColor = .bgDefaultGrey
            $0.configure(
                leftItem: .back,
                centerItem: .title("프로필")
            )
        }

        scrollView.do {
            $0.backgroundColor = .bgDefaultGrey
            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = true
            $0.contentInsetAdjustmentBehavior = .never
        }

        contentView.do {
            $0.backgroundColor = .bgDefaultGrey
        }

        profileCardImageView.do {
            $0.image = .hostProfileCard
            $0.contentMode = .scaleToFill
            $0.clipsToBounds = false
            $0.isUserInteractionEnabled = true
        }

        [
            mannerScoreCardView,
            introductionCardView,
            reviewCardView
        ].forEach {
            configureCardStyle($0)
        }

        nameStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 10
        }

        nicknameLabel.do {
            $0.font = NearbyFont.h3Sb20.font
            $0.textColor = .grey80
            $0.textAlignment = .center
            $0.numberOfLines = 1
        }

        genderLabel.do {
            $0.font = NearbyFont.b1M18.font
            $0.textColor = .primary50
            $0.textAlignment = .center
            $0.numberOfLines = 1
        }

        verificationChip.do {
            $0.isUserInteractionEnabled = false
        }

        [
            personalityFirstLineStackView,
            personalitySecondLineStackView
        ].forEach {
            configurePersonalityStackView($0)
        }

        mannerTitleLabel.do {
            $0.font = NearbyFont.b1Sb18.font
            $0.text = "매너 지수"
            $0.textColor = .grey80
            $0.numberOfLines = 1
        }

        introductionTitleLabel.do {
            $0.font = NearbyFont.b1Sb18.font
            $0.text = "한줄 소개"
            $0.textColor = .grey80
            $0.numberOfLines = 1
        }

        introductionLabel.do {
            $0.setFont(.b3R14, text: "", textColor: UIColor(red: 115 / 255, green: 115 / 255, blue: 115 / 255, alpha: 1))
            $0.numberOfLines = 3
            $0.lineBreakMode = .byTruncatingTail
        }

        reviewTitleLabel.do {
            $0.setFont(.b1Sb18, text: "지난 동행 후기", textColor: .grey80)
            $0.numberOfLines = 1
        }

        communicationTitleLabel.do {
            $0.setFont(.b2M16, text: "배려 · 소통", textColor: .grey80)
            $0.numberOfLines = 1
        }

        punctualityTitleLabel.do {
            $0.setFont(.b2M16, text: "시간 약속", textColor: .grey80)
            $0.numberOfLines = 1
        }

        [
            communicationFirstLineStackView,
            communicationSecondLineStackView,
            punctualityFirstLineStackView,
            punctualitySecondLineStackView
        ].forEach {
            configureReviewStackView($0)
        }
    }

    override func setUI() {
        addSubviews(navigationBar, scrollView)

        scrollView.addSubview(contentView)

        contentView.addSubviews(
            profileCardImageView, mannerScoreCardView,
            introductionCardView, reviewCardView
        )

        profileCardImageView.addSubviews(
            profileImageView, nameStackView,
            verificationChip, personalityChipContainerView
        )

        nameStackView.addArrangedSubviews(nicknameLabel, genderLabel)

        personalityChipContainerView.addSubviews(personalityFirstLineStackView, personalitySecondLineStackView)

        mannerScoreCardView.addSubviews(mannerTitleLabel, starRatingView)

        introductionCardView.addSubviews(introductionTitleLabel, introductionLabel)

        reviewCardView.addSubviews(reviewTitleLabel, communicationSectionView, punctualitySectionView)

        communicationSectionView.addSubviews(communicationTitleLabel, communicationChipContainerView)

        communicationChipContainerView.addSubviews(communicationFirstLineStackView, communicationSecondLineStackView)

        punctualitySectionView.addSubviews(punctualityTitleLabel, punctualityChipContainerView)

        punctualityChipContainerView.addSubviews(punctualityFirstLineStackView, punctualitySecondLineStackView)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

        setProfileCardLayout()
        setMannerScoreCardLayout()
        setIntroductionCardLayout()
        setReviewCardLayout()
    }

    override func setAddTarget() {
        navigationBar.leftButtonAction = { [weak self] in
            self?.onBackButtonDidTap?()
        }
    }

    // MARK: - Methods

    func configure(
        with displayData: HostProfileViewModel.DisplayData
    ) {
        profileImageView.configure(image: displayData.profileImage)

        nicknameLabel.text = displayData.nickname
        genderLabel.text = displayData.gender

        starRatingView.setRating(displayData.mannerScore)

        configureIntroductionText(displayData.introduction)

        configurePersonalityChips(displayData.personalityKeywords)

        configureCommunicationChips(displayData.communicationKeywords)

        configurePunctualityChips(displayData.punctualityKeywords)
    }

    func updateReviewChipSelection(
        selectedCommunicationIndexes: Set<Int>,
        selectedPunctualityIndexes: Set<Int>
    ) {
        communicationChipButtons.enumerated().forEach { index, chipButton in
            chipButton.updateSelected(selectedCommunicationIndexes.contains(index))
        }

        punctualityChipButtons.enumerated().forEach { index, chipButton in
            chipButton.updateSelected(selectedPunctualityIndexes.contains(index))
        }
    }
}

// MARK: - Custom Methods

private extension HostProfileView {

    func setProfileCardLayout() {
        profileCardImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(317)
        }

        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(80)
        }

        nameStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }

        verificationChip.snp.makeConstraints {
            $0.top.equalTo(nameStackView.snp.bottom).offset(-4)
            $0.centerX.equalToSuperview()
        }

        personalityChipContainerView.snp.makeConstraints {
            $0.top.equalTo(verificationChip.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(24)
        }

        personalityFirstLineStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36)
        }

        personalitySecondLineStackView.snp.makeConstraints {
            $0.top.equalTo(personalityFirstLineStackView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36)
            $0.bottom.equalToSuperview()
        }
    }

    func setMannerScoreCardLayout() {
        mannerScoreCardView.snp.makeConstraints {
            $0.top.equalTo(profileCardImageView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(103)
        }

        mannerTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }

        starRatingView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(54)
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(30)
        }
    }

    func setIntroductionCardLayout() {
        introductionCardView.snp.makeConstraints {
            $0.top.equalTo(mannerScoreCardView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(133)
        }

        introductionTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        introductionLabel.snp.makeConstraints {
            $0.top.equalTo(introductionTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualToSuperview().inset(16)
        }
    }

    func setReviewCardLayout() {
        reviewCardView.snp.makeConstraints {
            $0.top.equalTo(introductionCardView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(311)
            $0.bottom.equalToSuperview().inset(24)
        }

        reviewTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        communicationSectionView.snp.makeConstraints {
            $0.top.equalTo(reviewTitleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        communicationTitleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }

        communicationChipContainerView.snp.makeConstraints {
            $0.top.equalTo(communicationTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        communicationFirstLineStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.height.equalTo(36)
        }

        communicationSecondLineStackView.snp.makeConstraints {
            $0.top.equalTo(communicationFirstLineStackView.snp.bottom).offset(4)
            $0.leading.bottom.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.height.equalTo(36)
        }

        punctualitySectionView.snp.makeConstraints {
            $0.top.equalTo(communicationSectionView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualToSuperview().inset(16)
        }

        punctualityTitleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }

        punctualityChipContainerView.snp.makeConstraints {
            $0.top.equalTo(punctualityTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        punctualityFirstLineStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.height.equalTo(36)
        }

        punctualitySecondLineStackView.snp.makeConstraints {
            $0.top.equalTo(punctualityFirstLineStackView.snp.bottom).offset(4)
            $0.leading.bottom.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.height.equalTo(36)
        }
    }
}

// MARK: - Private Methods

private extension HostProfileView {

    func configureCardStyle(_ cardView: UIView) {
        cardView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }
    }

    func configurePersonalityStackView(_ stackView: UIStackView) {
        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 4
        }
    }

    func configureReviewStackView(_ stackView: UIStackView) {
        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 8
        }
    }

    func configurePersonalityChips(_ keywords: [String]) {
        removeAllArrangedSubviews(
            from: personalityFirstLineStackView
        )

        removeAllArrangedSubviews(
            from: personalitySecondLineStackView
        )

        keywords.enumerated().forEach { index, keyword in
            let chipButton = makePersonalityChip(title: keyword)

            if index < 3 {
                personalityFirstLineStackView.addArrangedSubview(chipButton)
            } else {
                personalitySecondLineStackView.addArrangedSubview(chipButton)
            }
        }
    }

    func configureCommunicationChips(_ keywords: [String]) {
        communicationChipButtons.removeAll()

        removeAllArrangedSubviews(from: communicationFirstLineStackView)
        removeAllArrangedSubviews(from: communicationSecondLineStackView)

        keywords.enumerated().forEach { index, keyword in
            let chipButton = makeReviewChip(
                title: keyword, category: .communication,
                index: index
            )

            communicationChipButtons.append(chipButton)

            if index < 2 {
                communicationFirstLineStackView.addArrangedSubview(chipButton)
            } else {
                communicationSecondLineStackView.addArrangedSubview(chipButton)
            }
        }
    }

    func configurePunctualityChips(_ keywords: [String]) {
        punctualityChipButtons.removeAll()

        removeAllArrangedSubviews(from: punctualityFirstLineStackView)
        removeAllArrangedSubviews(from: punctualitySecondLineStackView)

        keywords.enumerated().forEach { index, keyword in
            let chipButton = makeReviewChip(
                title: keyword, category: .punctuality,
                index: index
            )

            punctualityChipButtons.append(chipButton)

            if index < 2 {
                punctualityFirstLineStackView.addArrangedSubview(chipButton)
            } else {
                punctualitySecondLineStackView.addArrangedSubview(chipButton)
            }
        }
    }

    func makePersonalityChip(title: String) -> NearbyChipButton {
        let chipButton = NearbyChipButton(
            style: .personalityOrange,
            title: title,
            horizontalInset: 16
        )

        chipButton.isUserInteractionEnabled = false

        return chipButton
    }

    func makeReviewChip(title: String, category: HostProfileReviewCategory, index: Int) -> NearbyChipButton {
        let chipButton = NearbyChipButton(
            style: .tagStateUnselected,
            title: title,
            horizontalInset: 16
        )

        chipButton.tag = index

        switch category {
        case .communication:
            chipButton.addTarget(self, action: #selector(communicationChipButtonDidTap(_:)), for: .touchUpInside)

        case .punctuality:
            chipButton.addTarget(self, action: #selector(punctualityChipButtonDidTap(_:)), for: .touchUpInside)
        }

        return chipButton
    }

    func removeAllArrangedSubviews(
        from stackView: UIStackView
    ) {
        stackView.arrangedSubviews.forEach { arrangedSubview in

            stackView.removeArrangedSubview(arrangedSubview)

            arrangedSubview.removeFromSuperview()
        }
    }

    func configureIntroductionText(
        _ text: String
    ) {
        let font = NearbyFont.b2M16.font
        let lineHeight = font.pointSize * 1.3

        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.lineBreakMode = .byTruncatingTail

        let baselineOffset = (lineHeight - font.lineHeight) / 4

        introductionLabel.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: font, .foregroundColor: UIColor.grey50,
                .paragraphStyle: paragraphStyle, .baselineOffset: baselineOffset
            ]
        )
    }
}

// MARK: - Actions

private extension HostProfileView {

    @objc
    func communicationChipButtonDidTap(_ sender: NearbyChipButton) {
        onReviewChipDidTap?(.communication, sender.tag)
    }

    @objc
    func punctualityChipButtonDidTap(_ sender: NearbyChipButton) {
        onReviewChipDidTap?(.punctuality, sender.tag)
    }
}
