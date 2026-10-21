//
//  EditCompanionProfileView.swift
//  Nearby
//

import UIKit

import SnapKit
import Then

final class EditCompanionProfileView: BaseView {

    // MARK: - Properties

    var onSaveButtonDidTap: (() -> Void)?
    var onProfileImageButtonDidTap: (() -> Void)?
    var onNicknameDidChange: ((String) -> Void)?
    var onIntroductionDidChange: ((String) -> Void)?
    var onKeywordButtonDidTap: ((String) -> Void)?

    private(set) var keywordButtons: [NearbyChipButton] = []

    private var introductionTextViewHeightConstraint: Constraint?
    private let introductionTextViewMinimumHeight: CGFloat = 56

    // MARK: - UI Components

    let navigationBar = NearbyNavigationBar()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    let profileImageButton = UIButton(type: .system)
    private let profileImageView = UIImageView()
    private let imageSelectLabel = UILabel()

    private let nicknameTitleLabel = UILabel()
    private let nicknameTextFieldContainerView = UIView()
    let nicknameTextField = UITextField()
    let nicknameClearButton = UIButton(type: .system)

    private let introductionTitleLabel = UILabel()
    let introductionTextView = NearbyTextView(placeholder: "ex) 감성스팟과 맛집탐방을 좋아합니다")

    private let travelStyleTitleLabel = UILabel()
    private let travelStyleGuideLabel = UILabel()
    private let travelStyleStackView = UIStackView()

    let bottomButton = NearbyButton(style: .primary, title: "완료")

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        navigationBar.do {
            $0.configure(leftItem: .back, centerItem: .title("프로필 수정하기"))
        }

        scrollView.do {
            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = true
            $0.keyboardDismissMode = .interactive
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
            $0.tintColor = .grey80
        }

        introductionTitleLabel.do {
            $0.setFont(.b2Sb16, text: "나를 소개해주세요", textColor: .grey80)
        }

        introductionTextView.do {
            $0.textView.isScrollEnabled = false
        }

        travelStyleTitleLabel.do {
            $0.setFont(.b2Sb16, text: "여행스타일 키워드", textColor: .grey80)
        }

        travelStyleGuideLabel.do {
            $0.setFont(.c1M12, text: "최대 6개까지 선택할 수 있어요", textColor: .grey30)
        }

        travelStyleStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
            $0.alignment = .leading
        }
    }

    override func setUI() {
        addSubviews(navigationBar, scrollView, bottomButton)

        scrollView.addSubview(contentView)

        contentView.addSubviews(profileImageButton, nicknameTitleLabel, nicknameTextFieldContainerView, introductionTitleLabel, introductionTextView, travelStyleTitleLabel, travelStyleGuideLabel, travelStyleStackView)

        profileImageButton.addSubviews(profileImageView, imageSelectLabel)

        nicknameTextFieldContainerView.addSubviews(nicknameTextField, nicknameClearButton)

        setKeywordButtons()
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }

        bottomButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(14)
            $0.height.equalTo(56)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bottomButton.snp.top).offset(-12)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

        profileImageButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(140)
            $0.height.equalTo(164)
        }

        profileImageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }

        imageSelectLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
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

        introductionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextFieldContainerView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(20)
        }

        introductionTextView.snp.makeConstraints {
            $0.top.equalTo(introductionTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)

            introductionTextViewHeightConstraint = $0.height
                .equalTo(introductionTextViewMinimumHeight)
                .constraint
        }

        travelStyleTitleLabel.snp.makeConstraints {
            $0.top.equalTo(introductionTextView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(20)
        }

        travelStyleGuideLabel.snp.makeConstraints {
            $0.top.equalTo(travelStyleTitleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(20)
        }

        travelStyleStackView.snp.makeConstraints {
            $0.top.equalTo(travelStyleGuideLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    override func setAddTarget() {
        profileImageButton.addTarget(self, action: #selector(profileImageButtonDidTap), for: .touchUpInside)

        nicknameTextField.addTarget(self, action: #selector(nicknameDidChange), for: .editingChanged)

        nicknameClearButton.addTarget(self, action: #selector(nicknameClearButtonDidTap), for: .touchUpInside)

        bottomButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)

        introductionTextView.onTextChanged = { [weak self] text in
            self?.updateIntroductionTextViewHeight()
            self?.onIntroductionDidChange?(text)
        }

        keywordButtons.forEach { button in
            button.addTarget(self, action: #selector(keywordButtonDidTap(_:)), for: .touchUpInside)
        }
    }

    // MARK: - Methods

    func updateSelectedKeywords(_ selectedKeywords: Set<String>) {
        keywordButtons.forEach { button in
            button.updateSelected(selectedKeywords.contains(button.chipTitle))
        }
    }

    func updateProfileImage(_ image: UIImage) {
        profileImageView.image = image
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
    }

    func updateIntroductionTextViewHeight() {
        let textView = introductionTextView.textView

        let fittingSize = CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude)

        let textHeight = textView.sizeThatFits(fittingSize).height

        let containerHeight = max(introductionTextViewMinimumHeight, ceil(textHeight) + 32)

        introductionTextViewHeightConstraint?.update(offset: containerHeight)

        UIView.performWithoutAnimation {
            layoutIfNeeded()
        }
    }

    func configure(nickname: String, introduction: String?, selectedKeywords: Set<String>) {
        nicknameTextField.text = nickname

        let introductionText = introduction ?? ""
        introductionTextView.textView.text = introductionText

        introductionTextView.updatePlaceholder(isHidden: !introductionText.isEmpty)

        updateSelectedKeywords(selectedKeywords)

        setNeedsLayout()
        layoutIfNeeded()
        updateIntroductionTextViewHeight()
    }

    // MARK: - Action

    @objc
    private func profileImageButtonDidTap() {
        onProfileImageButtonDidTap?()
    }

    @objc
    private func nicknameDidChange() {
        onNicknameDidChange?(nicknameTextField.text ?? "")
    }

    @objc
    private func nicknameClearButtonDidTap() {
        nicknameTextField.text = ""
        onNicknameDidChange?("")
    }

    @objc
    private func keywordButtonDidTap(_ sender: NearbyChipButton) {
        onKeywordButtonDidTap?(sender.chipTitle)
    }

    @objc
    private func saveButtonDidTap() {
        onSaveButtonDidTap?()
    }
}

// MARK: - Private Methods

private extension EditCompanionProfileView {

    func setKeywordButtons() {
        let keywordRows = [
            ["외향형", "내향형", "계획형", "즉흥형"],
            ["느좋 카페 투어", "도보여행", "사진 맛집 투어"],
            ["미식 탐방", "디저트 중독", "소품샵 투어"],
            ["야경 러버", "역사 탐방", "전시장 러버"],
            ["한 곳 오래", "많이 도는형", "음주 애호가"],
            ["음주 비선호"]
        ]

        keywordRows.forEach { rowKeywords in
            let rowStackView = UIStackView()

            rowStackView.axis = .horizontal
            rowStackView.spacing = 4
            rowStackView.alignment = .center

            rowKeywords.forEach { keyword in
                let chipButton = NearbyChipButton(style: .personalityDefault, title: keyword, horizontalInset: 16)

                keywordButtons.append(chipButton)
                rowStackView.addArrangedSubview(chipButton)
            }

            travelStyleStackView.addArrangedSubview(rowStackView)
        }
    }
}
