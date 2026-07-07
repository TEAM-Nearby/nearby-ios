//
//  CompanionProfileView.swift
//  Nearby
//
//  Created by 신서연 on 7/7/26.
//

import UIKit

import SnapKit
import Then

final class CompanionProfileView: BaseView {
    
    // MARK: - UI Components
    
    let navigationBar = NearbyNavigationBar()
    
    private let progressContainerView = UIView()
    private let progressView = UIProgressView(progressViewStyle: .default)
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let profileImageButton = UIButton(type: .system)
    private let profileImageView = UIImageView()
    private let imageSelectLabel = UILabel()
    
    private let nicknameTitleLabel = UILabel()
    private let nicknameTextFieldContainerView = UIView()
    let nicknameTextField = UITextField()
    let nicknameClearButton = UIButton(type: .system)
    
    private let genderTitleLabel = UILabel()
    private let genderStackView = UIStackView()
    let maleButton = UIButton(type: .system)
    let femaleButton = UIButton(type: .system)
    
    private let introductionTitleLabel = UILabel()
    private let introductionTextViewContainerView = UIView()
    let introductionTextView = UITextView()
    let introductionClearButton = UIButton(type: .system)
    
    private let travelStyleTitleLabel = UILabel()
    private let travelStyleStackView = UIStackView()
    let bottomButton = NearbyButton(style: .primary, title: "완료")
    
    private(set) var keywordButtons: [NearbyChipButton] = []
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .white
        
        navigationBar.do {
            $0.configure(leftItem: .back)
        }
        
        progressContainerView.do {
            $0.backgroundColor = .white
        }
        
        progressView.do {
            $0.progress = 0.5
            $0.progressTintColor = .btnPrimaryBg
            $0.trackTintColor = .chipBgPurple
            $0.transform = CGAffineTransform(scaleX: -1, y: 1)
            $0.layer.cornerRadius = 2
            $0.clipsToBounds = true
        }
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = true
        }
        
        titleLabel.do {
            $0.setFont(
                .h3Sb20,
                text: "동행 프로필을 만들어볼까요?",
                textColor: .grey80
            )
        }
        
        descriptionLabel.do {
            $0.numberOfLines = 1
            $0.setFont(
                .b3M14,
                text: "동행을 구할 때, 상대에게 보여지는 내 소개에요.",
                textColor: .grey50
            )
        }
        
        profileImageButton.do {
            $0.backgroundColor = .clear
        }
        
        profileImageView.do {
            $0.image = .imgProfileDefault
            $0.contentMode = .scaleAspectFit
        }
        
        imageSelectLabel.do {
            $0.textAlignment = .center
            $0.setFont(.b3M14, text: "이미지 선택", textColor: .grey30)
        }
        
        nicknameTitleLabel.do {
            $0.setFont(.b2Sb16, text: "닉네임", textColor: .grey80)
        }
        
        nicknameTextFieldContainerView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }
        
        nicknameTextField.do {
            $0.borderStyle = .none
            $0.font = NearbyFont.b3M14.font
            $0.textColor = .grey80
            $0.attributedPlaceholder = NSAttributedString(
                string: "닉네임을 입력해주세요",
                attributes: [.foregroundColor: UIColor.grey20]
            )
        }
        
        nicknameClearButton.do {
            $0.setImage(.cancelIcon.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .grey20
            $0.isHidden = true
        }
        
        genderTitleLabel.do {
            $0.setFont(.b2Sb16, text: "성별", textColor: .grey80)
        }
        
        genderStackView.do {
            $0.axis = .horizontal
            $0.spacing = 48
        }
        
        maleButton.do {
            $0.setGenderTitle("남성", isSelected: true)
        }
        
        femaleButton.do {
            $0.setGenderTitle("여성", isSelected: false)
        }
        
        introductionTitleLabel.do {
            $0.setFont(.b2Sb16, text: "나를 소개해주세요", textColor: .grey80)
        }
        
        introductionTextViewContainerView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }
        
        introductionTextView.do {
            $0.backgroundColor = .clear
            $0.font = NearbyFont.b3M14.font
            $0.textColor = .grey80
            $0.textContainerInset = .zero
            $0.textContainer.lineFragmentPadding = 0
        }
        
        introductionClearButton.do {
            $0.setImage(.cancelIcon.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .grey20
            $0.isHidden = true
        }
        
        travelStyleTitleLabel.do {
            $0.setFont(.b2Sb16, text: "여행스타일 키워드", textColor: .grey80)
        }
        
        travelStyleStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
            $0.alignment = .leading
        }
    }
    
    override func setUI() {
        addSubviews(
            navigationBar,
            progressContainerView,
            scrollView,
            bottomButton
        )
        
        progressContainerView.addSubview(progressView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(
            titleLabel,
            descriptionLabel,
            profileImageButton,
            nicknameTitleLabel,
            nicknameTextFieldContainerView,
            genderTitleLabel,
            genderStackView,
            introductionTitleLabel,
            introductionTextViewContainerView,
            travelStyleTitleLabel,
            travelStyleStackView
        )
        
        profileImageButton.addSubviews(profileImageView, imageSelectLabel)
        nicknameTextFieldContainerView.addSubviews(nicknameTextField, nicknameClearButton)
        genderStackView.addArrangedSubviews(maleButton, femaleButton)
        introductionTextViewContainerView.addSubviews(introductionTextView, introductionClearButton)
        
        setKeywordButtons()
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        progressContainerView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(28)
        }
        
        progressView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        bottomButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(14)
            $0.height.equalTo(56)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(progressContainerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bottomButton.snp.top).offset(-12)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        profileImageButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(56)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(140)
            $0.height.equalTo(164)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        imageSelectLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        nicknameTitleLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageButton.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
        }
        
        nicknameTextFieldContainerView.snp.makeConstraints {
            $0.top.equalTo(nicknameTitleLabel.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(28)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(nicknameClearButton.snp.leading).offset(-12)
        }
        
        nicknameClearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        genderTitleLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextFieldContainerView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(20)
        }
        
        genderStackView.snp.makeConstraints {
            $0.top.equalTo(genderTitleLabel.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(24)
        }
        
        introductionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(genderStackView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        introductionTextViewContainerView.snp.makeConstraints {
            $0.top.equalTo(introductionTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(72)
        }
        
        introductionTextView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(28)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(introductionClearButton.snp.leading).offset(-12)
            $0.height.equalTo(22)
        }
        
        introductionClearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(28)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        travelStyleTitleLabel.snp.makeConstraints {
            $0.top.equalTo(introductionTextViewContainerView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(20)
        }
        
        travelStyleStackView.snp.makeConstraints {
            $0.top.equalTo(travelStyleTitleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    func updateGender(selectedGender: CompanionProfileGender) {
        maleButton.setGenderTitle("남성", isSelected: selectedGender == .male)
        femaleButton.setGenderTitle("여성", isSelected: selectedGender == .female)
    }
    
    func updateSelectedKeywords(_ selectedKeywords: Set<String>) {
        keywordButtons.forEach {
            $0.updateSelected(selectedKeywords.contains($0.chipTitle))
        }
    }
    
    func clearNicknameText() {
        nicknameTextField.text = nil
        nicknameClearButton.isHidden = true
    }
    
    func clearIntroductionText() {
        introductionTextView.text = nil
        introductionClearButton.isHidden = true
    }
    
    // MARK: - Method
    
    private func setKeywordButtons() {
        let keywordRows = [
            ["외향형", "내향형", "계획형", "즉흥형"],
            ["느좋 카페 투어", "도보여행", "사진 맛집 투어"],
            ["미식 탐방", "디저트 중독", "소품샵 투어"],
            ["야경 러버", "역사 탐방", "전시장 러버"],
            ["한 곳 오래", "많이 도는형", "문화 예술"]
        ]

        keywordRows.forEach { rowKeywords in
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 8
            rowStackView.alignment = .center

            rowKeywords.forEach { keyword in
                let chipButton = NearbyChipButton(
                    style: .profileKeywordUnselected,
                    title: keyword,
                    horizontalInset: 20
                )

                keywordButtons.append(chipButton)
                rowStackView.addArrangedSubview(chipButton)
            }

            travelStyleStackView.addArrangedSubview(rowStackView)
        }
    }
}

// MARK: - UILabel Extension

private extension UILabel {
    func setRequiredTitle(_ title: String) {
        let attributedString = NSMutableAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor.grey80,
                .font: NearbyFont.h3Sb20.font
            ]
        )

        attributedString.append(
            NSAttributedString(
                string: "*",
                attributes: [
                    .foregroundColor: UIColor.highlightRed,
                    .font: NearbyFont.h3Sb20.font
                ]
            )
        )

        self.attributedText = attributedString
    }
}

// MARK: - UIButton Extension

private extension UIButton {
    func setGenderTitle(_ title: String, isSelected: Bool) {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(
            systemName: isSelected ? "largecircle.fill.circle" : "circle"
        )
        configuration.imagePlacement = .leading
        configuration.imagePadding = 12
        configuration.baseForegroundColor = isSelected ? .btnPrimaryBg : .grey50

        self.configuration = configuration

        setAttributedTitle(
            NSAttributedString(
                string: title,
                attributes: [
                    .foregroundColor: UIColor.grey70,
                    .font: NearbyFont.b2M16.font
                ]
            ),
            for: .normal
        )
    }
}
