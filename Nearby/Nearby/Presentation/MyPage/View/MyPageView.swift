//
//  MyPageView.swift
//  Nearby
//
//  Created by 신서연 on 7/9/26.
//

import UIKit

import SnapKit
import Then

final class MyPageView: BaseView {

    // MARK: - Properties

    var onWrittenPostRowDidTap: (() -> Void)?
    var onSentRequestRowDidTap: (() -> Void)?
    var onReceivedRequestRowDidTap: (() -> Void)?
    var onEditProfileButtonDidTap: (() -> Void)?

    private let isGuest: Bool
    private let gradientLayer = CAGradientLayer()

    // MARK: - UI Components

    let navigationBar = NearbyNavigationBar()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let boardingPassImageView = UIImageView()
    private let editProfileButton = UIButton(type: .system)
    private let guestProfileImageView = UIImageView(image: .imgProfileDefault)
    private let profileImageView = GradientCircleView(diameter: 80)
    private let nameStackView = UIStackView()
    private let nicknameLabel = UILabel()
    private let genderLabel = UILabel()
    private let introductionContainerView = UIView()
    private let introductionTitleLabel = UILabel()
    private let introductionLabel = UILabel()
    private let verificationChip = NearbyChipButton(style: .badgeVerification, title: "본인인증 완료", horizontalInset: 22)
    private let personalityVerticalGuide = UILayoutGuide()
    private let personalityChipContainerView = UIView()
    private let personalityFirstLineStackView = UIStackView()
    private let personalitySecondLineStackView = UIStackView()
    private let statsStackView = UIStackView()

    private let mealStatView = MyPageStatItemView(icon: .icRestaurant, title: "함께한 식사", value: "0회")
    private let cityStatView = MyPageStatItemView(icon: .cityIcon, title: "방문한 도시", value: "0곳")
    private let reviewStatView = MyPageStatItemView(icon: .starIcon, title: "받은 후기", value: "0개")

    private let firstDividerView = UIView()
    private let secondDividerView = UIView()

    private let mannerScoreCardView = UIView()
    private let mannerTitleLabel = UILabel()
    private let starRatingView = StarRatingView()
    private let mannerChipContainerView = UIView()
    private let mannerKeywordStackView = UIStackView()

    private let menuCardView = UIView()

    private let writtenPostRowView = MyPageMenuRowView(title: "내가 작성한 모집글")
    private let sentRequestRowView = MyPageMenuRowView(title: "보낸 요청")
    private let receivedRequestRowView = MyPageMenuRowView(title: "받은 요청")

    // MARK: - Initializer

    init(isGuest: Bool = false) {
        self.isGuest = isGuest
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds
    }

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        gradientLayer.do {
            $0.colors = [
                UIColor(red: 220 / 255, green: 215 / 255, blue: 255 / 255, alpha: 1).cgColor,
                UIColor(red: 250 / 255, green: 250 / 255, blue: 255 / 255, alpha: 1).cgColor
            ]
            $0.startPoint = CGPoint(x: 0.5, y: 0.0)
            $0.endPoint = CGPoint(x: 0.5, y: 1.0)
        }

        navigationBar.do {
            $0.backgroundColor = .clear
            $0.configure(
                centerItem: .title("마이페이지"),
                rightItems: [.alarm, .setting]
            )
        }

        scrollView.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = true
        }

        contentView.do {
            $0.backgroundColor = .clear
        }

        boardingPassImageView.do {
            $0.image = .mypageWithoutIntro
            $0.contentMode = .scaleToFill
            $0.isUserInteractionEnabled = true
        }

        editProfileButton.do {
            $0.setTitle("수정하기", for: .normal)
            $0.setTitleColor(.grey50, for: .normal)
            $0.titleLabel?.font = NearbyFont.b3M14.font
            $0.backgroundColor = .clear
        }

        nameStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 10
        }

        nicknameLabel.do {
            $0.font = NearbyFont.h3Sb20.font
            $0.text = ""
            $0.textColor = .grey80
        }

        genderLabel.do {
            $0.font = NearbyFont.b1M18.font
            $0.text = ""
            $0.textColor = .primary50
        }

        introductionContainerView.do {
            $0.backgroundColor = .primary5
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
            $0.isHidden = true
        }

        introductionTitleLabel.do {
            $0.text = "나의 한 줄 소개"
            $0.font = NearbyFont.b2Sb16.font
            $0.textColor = .primary50
        }

        introductionLabel.do {
            $0.font = NearbyFont.b3M14.font
            $0.textColor = .grey80
            $0.textAlignment = .left
            $0.numberOfLines = 0
        }

        verificationChip.do {
            $0.isUserInteractionEnabled = false
        }

        [personalityFirstLineStackView, personalitySecondLineStackView].forEach {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .equalSpacing
            $0.spacing = 4
        }

        statsStackView.do {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }

        [firstDividerView, secondDividerView].forEach {
            $0.backgroundColor = .grey5
        }

        mannerScoreCardView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }

        mannerTitleLabel.do {
            $0.font = NearbyFont.b1Sb18.font
            $0.text = "매너지수"
            $0.textColor = .black
        }

        starRatingView.do {
            $0.setRating(0)
        }

        mannerKeywordStackView.do {
            $0.axis = .vertical
            $0.alignment = .leading
            $0.distribution = .fill
            $0.spacing = 4
        }

        menuCardView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }

        guestProfileImageView.contentMode = .scaleAspectFit
        guestProfileImageView.isHidden = !isGuest

        if isGuest {
            profileImageView.isHidden = true
            editProfileButton.isHidden = true
            genderLabel.isHidden = true
            verificationChip.isHidden = true
            personalityChipContainerView.isHidden = true
            mannerChipContainerView.isHidden = true
            nicknameLabel.text = "로그인이 필요해요"
            introductionContainerView.isHidden = false
            introductionLabel.text = "로그인 후 프로필을 만들어보세요!"
            [mealStatView, cityStatView, reviewStatView].forEach { $0.setGuestAppearance() }
        }
    }

    override func setUI() {
        layer.insertSublayer(gradientLayer, at: 0)

        addSubviews(scrollView, navigationBar)

        scrollView.addSubview(contentView)

        contentView.addSubviews(boardingPassImageView, mannerScoreCardView, menuCardView)

        boardingPassImageView.addSubviews(
            profileImageView, guestProfileImageView, nameStackView, introductionContainerView,
            verificationChip, personalityChipContainerView, statsStackView,
            firstDividerView, secondDividerView, editProfileButton
        )

        introductionContainerView.addSubviews(introductionTitleLabel, introductionLabel)

        boardingPassImageView.addLayoutGuide(personalityVerticalGuide)

        nameStackView.addArrangedSubviews(nicknameLabel, genderLabel)

        personalityChipContainerView.addSubviews(
            personalityFirstLineStackView, personalitySecondLineStackView
        )

        statsStackView.addArrangedSubviews(mealStatView, cityStatView, reviewStatView)

        mannerScoreCardView.addSubviews(
            mannerTitleLabel, starRatingView, mannerChipContainerView
        )

        mannerChipContainerView.addSubview(mannerKeywordStackView)

        menuCardView.addSubviews(writtenPostRowView, sentRequestRowView, receivedRequestRowView)
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

        boardingPassImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        editProfileButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(32)
        }

        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(isGuest ? 32 : 20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(80)
        }

        guestProfileImageView.snp.makeConstraints {
            $0.edges.equalTo(profileImageView)
        }

        nameStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }

        verificationChip.snp.makeConstraints {
            $0.top.equalTo(nameStackView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36)
        }

        introductionContainerView.snp.makeConstraints {
            $0.top.equalTo(isGuest ? nameStackView.snp.bottom : verificationChip.snp.bottom).offset(isGuest ? 44 : 32)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }

        introductionTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        introductionLabel.snp.makeConstraints {
            $0.top.equalTo(introductionTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }

        personalityVerticalGuide.snp.makeConstraints {
            $0.top.equalTo(introductionContainerView.snp.bottom)
            $0.bottom.equalTo(statsStackView.snp.top)
            $0.horizontalEdges.equalToSuperview()
        }

        if !isGuest {
            personalityChipContainerView.snp.remakeConstraints {
                $0.top.equalTo(introductionContainerView.snp.bottom).offset(24)
                $0.centerX.equalToSuperview()
                $0.horizontalEdges.greaterThanOrEqualToSuperview().inset(25)
                $0.bottom.equalTo(statsStackView.snp.top).offset(-24)
            }

            personalityFirstLineStackView.snp.makeConstraints {
                $0.top.centerX.equalToSuperview()
                $0.height.equalTo(36)
            }

            personalitySecondLineStackView.snp.makeConstraints {
                $0.top.equalTo(personalityFirstLineStackView.snp.bottom).offset(4)
                $0.centerX.bottom.equalToSuperview()
                $0.height.equalTo(36)
            }
        }

        statsStackView.snp.makeConstraints {
            if isGuest {
                $0.top.equalTo(introductionContainerView.snp.bottom).offset(24)
            }
            $0.horizontalEdges.equalToSuperview().inset(25)
            $0.height.equalTo(79)
            $0.bottom.equalToSuperview().inset(20)
        }

        firstDividerView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.top.bottom.equalTo(statsStackView)
            $0.centerX.equalTo(mealStatView.snp.trailing)
        }

        secondDividerView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.top.bottom.equalTo(statsStackView)
            $0.centerX.equalTo(cityStatView.snp.trailing)
        }

        mannerScoreCardView.snp.makeConstraints {
            $0.top.equalTo(boardingPassImageView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        mannerTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(20)
        }

        starRatingView.snp.makeConstraints {
            $0.top.equalTo(mannerTitleLabel.snp.bottom).offset(17)
            $0.leading.equalToSuperview().offset(54)
            $0.trailing.equalToSuperview().inset(54)
            $0.height.equalTo(30)
        }

        mannerChipContainerView.snp.makeConstraints {
            $0.top.equalTo(starRatingView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(24)
        }

        mannerKeywordStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        menuCardView.snp.makeConstraints {
            $0.top.equalTo(mannerScoreCardView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(160)
            $0.bottom.equalToSuperview().inset(12)
        }

        writtenPostRowView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(53)
        }

        sentRequestRowView.snp.makeConstraints {
            $0.top.equalTo(writtenPostRowView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(53)
        }

        receivedRequestRowView.snp.makeConstraints {
            $0.top.equalTo(sentRequestRowView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
            $0.bottom.equalToSuperview()
        }
        if isGuest { updateMannerScoreLayout(hasKeywords: false) }
    }

    override func setAddTarget() {
        writtenPostRowView.onTap = { [weak self] in
            self?.onWrittenPostRowDidTap?()
        }

        sentRequestRowView.onTap = { [weak self] in
            self?.onSentRequestRowDidTap?()
        }

        receivedRequestRowView.onTap = { [weak self] in
            self?.onReceivedRequestRowDidTap?()
        }

        editProfileButton.addTarget(self, action: #selector(editProfileButtonDidTap), for: .touchUpInside)
    }

    func configure(with item: MyPageDisplayModel) {
        guard !isGuest else { return }
        profileImageView.configure(imageUrl: item.profileImageUrl)

        nicknameLabel.text = item.nickname
        genderLabel.text = item.genderText

        configureIntroduction(item.intro)

        verificationChip.isHidden = !item.isPhoneVerified

        mealStatView.updateValue(item.mealTogetherCountText)

        cityStatView.updateValue(item.visitedCityCountText)

        reviewStatView.updateValue(item.receivedReviewCountText)

        starRatingView.setRating(item.mannerRating)

        configurePersonalityKeywords(item.travelStyleKeywords)

        configureMannerKeywords(item.mannerKeywords)
    }

    // MARK: - Action

    @objc
    private func editProfileButtonDidTap() {
        onEditProfileButtonDidTap?()
    }
}

// MARK: - Private Methods

private extension MyPageView {

    func configureIntroduction(_ introduction: String?) {
        let text = introduction?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let hasIntroduction = !text.isEmpty
        
        boardingPassImageView.image = hasIntroduction ? .mypageWithIntro : .mypageWithoutIntro

        introductionLabel.text = text
        introductionContainerView.isHidden = !hasIntroduction

        introductionContainerView.snp.remakeConstraints {
            $0.top.equalTo(verificationChip.snp.bottom).offset(hasIntroduction ? 32 : 0)
            $0.horizontalEdges.equalToSuperview().inset(24)

            if !hasIntroduction {
                $0.height.equalTo(0)
            }
        }

        setNeedsLayout()
    }

    func configurePersonalityKeywords(_ keywords: [String]) {
        removeAllArrangedSubviews(from: personalityFirstLineStackView)
        removeAllArrangedSubviews(from: personalitySecondLineStackView)

        keywords.enumerated().forEach { index, keyword in
            let chip = makePersonalityChip(title: keyword)

            if index < 3 {
                personalityFirstLineStackView.addArrangedSubview(chip)
            } else {
                personalitySecondLineStackView.addArrangedSubview(chip)
            }
        }

        let hasSecondLine = keywords.count > 3

        personalitySecondLineStackView.isHidden = !hasSecondLine

        updatePersonalityChipLayout(hasSecondLine: hasSecondLine)
    }

    func configureMannerKeywords(_ keywords: [String]) {
        removeAllArrangedSubviews(from: mannerKeywordStackView)

        let keywordRows = stride(from: 0, to: keywords.count, by: 2)

        keywordRows.forEach { startIndex in
            let rowStackView = makeMannerKeywordRowStackView()

            let endIndex = min(startIndex + 2, keywords.count)

            for index in startIndex..<endIndex {
                let chip = makeMannerChip(title: keywords[index])
                rowStackView.addArrangedSubview(chip)
            }

            mannerKeywordStackView.addArrangedSubview(rowStackView)
        }

        let hasMannerKeywords = !keywords.isEmpty

        mannerChipContainerView.isHidden = !hasMannerKeywords

        updateMannerScoreLayout(hasKeywords: hasMannerKeywords)
    }

    func updateMannerScoreLayout(hasKeywords: Bool) {
        starRatingView.snp.remakeConstraints {
            $0.top.equalTo(mannerTitleLabel.snp.bottom).offset(17)
            $0.leading.equalToSuperview().offset(54)
            $0.trailing.equalToSuperview().inset(54)
            $0.height.equalTo(30)

            if !hasKeywords {
                $0.bottom.equalToSuperview().inset(20)
            }
        }

        if hasKeywords {
            mannerChipContainerView.snp.remakeConstraints {
                $0.top.equalTo(starRatingView.snp.bottom).offset(20)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview().inset(24)
            }
        } else {
            mannerChipContainerView.snp.remakeConstraints {
                $0.top.equalTo(starRatingView.snp.bottom)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.height.equalTo(0)
            }
        }

        setNeedsLayout()
    }

    func removeAllArrangedSubviews(from stackView: UIStackView) {
        stackView.arrangedSubviews.forEach { arrangedSubview in
            stackView.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
    }

    func makePersonalityChip(title: String) -> NearbyChipButton {
        let chip = NearbyChipButton(style: .personalityOrange, title: title, horizontalInset: 16)

        chip.isUserInteractionEnabled = false

        chip.snp.makeConstraints {
            $0.height.equalTo(36)
        }

        return chip
    }

    func makeMannerChip(title: String) -> NearbyChipButton {
        let chip = NearbyChipButton(style: .tagStateSelected, title: title, horizontalInset: 16)
        chip.isUserInteractionEnabled = false

        chip.snp.makeConstraints {
            $0.height.equalTo(36)
        }

        return chip
    }

    func updatePersonalityChipLayout(hasSecondLine: Bool) {
        personalityFirstLineStackView.snp.remakeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36)

            if !hasSecondLine {
                $0.bottom.equalToSuperview()
            }
        }

        personalitySecondLineStackView.snp.remakeConstraints {
            $0.centerX.equalToSuperview()

            if hasSecondLine {
                $0.top.equalTo(personalityFirstLineStackView.snp.bottom).offset(8)
                $0.height.equalTo(36)
                $0.bottom.equalToSuperview()
            } else {
                $0.top.equalTo(personalityFirstLineStackView.snp.bottom)
                $0.height.equalTo(0)
            }
        }

        personalityChipContainerView.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.greaterThanOrEqualToSuperview().inset(25)

            if hasSecondLine {
                let hasIntroduction = !introductionContainerView.isHidden

                if hasIntroduction {
                    $0.top.equalTo(introductionContainerView.snp.bottom).offset(17)
                } else {
                    $0.top.equalTo(verificationChip.snp.bottom).offset(32)
                }

                $0.bottom.lessThanOrEqualTo(statsStackView.snp.top).offset(-24)
            } else {
                $0.centerY.equalTo(personalityVerticalGuide.snp.centerY)
            }
        }

        setNeedsLayout()
        layoutIfNeeded()
    }

    func makeMannerKeywordRowStackView() -> UIStackView {
        let stackView = UIStackView()

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 4

        stackView.snp.makeConstraints {
            $0.height.equalTo(36)
        }

        return stackView
    }
}

// MARK: - MyPageStatItemView

private final class MyPageStatItemView: UIView {

    // MARK: - UI Components

    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    // MARK: - Initializer

    init(icon: UIImage?, title: String, value: String) {
        super.init(frame: .zero)

        setStyle(icon: icon, title: title, value: value)
        setUI()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Methods

    func setGuestAppearance() {
        valueLabel.textColor = .grey40
    }

    func updateValue(_ value: String) {
        valueLabel.text = value
    }
}

// MARK: - Private Methods

private extension MyPageStatItemView {
    func setStyle(icon: UIImage?, title: String, value: String) {
        backgroundColor = .clear

        iconImageView.do {
            $0.image = icon?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .grey30
            $0.contentMode = .scaleAspectFit
        }

        titleLabel.do {
            $0.setFont(.b3M14, text: title, textColor: .grey40)
            $0.textAlignment = .center
        }

        valueLabel.do {
            $0.setFont(.b1Sb18, text: value, textColor: .black)
            $0.textAlignment = .center
        }
    }

    func setUI() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(valueLabel)
    }

    func setLayout() {
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }

        valueLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}

// MARK: - MyPageMenuRowView

private final class MyPageMenuRowView: UIView {

    // MARK: - Properties

    var onTap: (() -> Void)?

    // MARK: - UI Components

    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let tapButton = UIButton(type: .system)

    // MARK: - Initializer

    init(title: String) {
        super.init(frame: .zero)

        setStyle(title: title)
        setUI()
        setLayout()
        setAddTarget()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension MyPageMenuRowView {
    func setStyle(title: String) {
        backgroundColor = .clear

        titleLabel.do {
            $0.setFont(.b2M16, text: title, textColor: .grey80)
        }

        arrowImageView.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = .black
            $0.contentMode = .scaleAspectFit
        }

        tapButton.do {
            $0.backgroundColor = .clear
        }
    }

    func setUI() {
        addSubviews(titleLabel, arrowImageView, tapButton)
    }

    func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }

        arrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(13)
            $0.height.equalTo(23)
        }

        tapButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setAddTarget() {
        tapButton.addTarget(self, action: #selector(rowDidTap), for: .touchUpInside)
    }

}

// MARK: - Action

private extension MyPageMenuRowView {
    @objc
    func rowDidTap() {
        onTap?()
    }
}
