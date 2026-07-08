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
    
    // MARK: - UI Components

    private let navigationBar = NearbyNavigationBar()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let whenTitleLabel = UILabel()
    private let nowButton = NearbyButton(style: .selected, title: "지금 바로")
    private let timeButton = NearbyButton(style: .unselected, title: "시간 설정")
    private let buttonStackView = UIStackView()
    private let datePicker = NearbyDateTimePickerView()
    private let peopleStepper = NearbyStepper(count: 2)
    private let peopleNumber = UILabel()
    private let peopleTitleLabel = UILabel()
    private let peopleButton = UIButton()
    private let peopleTopDivider = UIView()
    private let peopleExplainLabel = UILabel()
    private let peopleBottomDivider = UIView()
    private let tagTitleLabel = UILabel()
    private let tagTitles = [
        "사진에 진심인", "리액션이 좋은", "차분한 성격",
        "정보 공유 환영", "새로운 음식 도전", "음식 쉐어 가능",
        "파워 J형", "파워 P형", "술 한잔 가능"
    ]
    private lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeTagLayout())
    private let tagBottomDivider = UIView()
    private let meetingPlaceTitleLabel = UILabel()
    private let meetingPlaceTextView = NearbyTextView(
        placeholder: "입력창입력창입력창입력창입력창입력창입력창..."
    )
    private let descriptionTitleLabel = UILabel()
    private let descriptionTextView = NearbyTextView(
        placeholder: "ex) 20대 여자입니다. 맛집 탐방하는 걸 좋아해요 :)\n"
            + "사진 잘 찍어드릴 수 있습니다!\n"
            + "같이 재미있게 놀아요..."
    )
    private let kakaoLinkTitleLabel = UILabel()
    private let kakaoLinkTextView = NearbyTextView(placeholder: "오픈채팅방 링크(URL)를 입력해 주세요")
    private let completeButton = NearbyButton(style: .primary, title: "작성 완료하기")
    
    // MARK: - Properties

    private var peopleTitleTopFromButtonConstraint: Constraint?
    private var peopleTitleTopFromDatePickerConstraint: Constraint?
    private var peopleCheckBoxTopFromTitleConstraint: Constraint?
    private var peopleCheckBoxTopFromStepperConstraint: Constraint?
    private var descriptionTextViewHeightConstraint: Constraint?
    private var selectedTagIndexes = Set<Int>()
    private var descriptionTextViewMinimumHeight: CGFloat {
        return ceil(NearbyFont.b3M14.font.lineHeight * 3) + 32
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .white

        navigationBar.configure(leftItem: .back, centerItem: .title("동행 모집하기"))

        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }

        whenTitleLabel.do {
            $0.setFont(.b1Sb18, text: "언제 만날 예정인가요?", textColor: .grey80)
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.distribution = .fillEqually
        }
        
        nowButton.setSelected(true)
        datePicker.isHidden = true
        
        peopleTitleLabel.do {
            $0.setFont(.b1Sb18, text: "최대 몇 명과 함께 갈까요?", textColor: .grey80)
        }
        
        peopleNumber.do {
            $0.setFont(.h3Sb20, text: "2명", textColor: .primary50)
        }

        peopleStepper.isHidden = true

        [peopleTopDivider, peopleBottomDivider, tagBottomDivider].forEach {
            $0.backgroundColor = .grey5
        }
        
        peopleButton.setImage(.chevronDownIcon, for: .normal)
        peopleButton.setImage(.chevronUpIcon, for: .selected)
        
        peopleExplainLabel.do {
            $0.setFont(.b2M16, text: "목표 인원이 안 차도 출발할 수 있어요", textColor: .grey30)
        }
        
        tagTitleLabel.do {
            $0.setFont(.b1Sb18, text: "어떤 동행과 함께하고 싶나요?", textColor: .grey80)
        }
        
        tagCollectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
            $0.dataSource = self
            $0.delegate = self
        }
        
        meetingPlaceTitleLabel.do {
            $0.setFont(.b1Sb18, text: "어디서 만날까요?")
        }
        
        meetingPlaceTextView.do {
            $0.updatePlaceholder(isHidden: false)
            $0.clearButton.setImage(UIImage(named: "search_icon"), for: .normal)
            $0.clearButton.tintColor = .grey40
            $0.clearButton.isHidden = false
            $0.setPlaceholderTruncation(numberOfLines: 1)
            $0.textView.isScrollEnabled = false
        }
        
        descriptionTitleLabel.do {
            $0.setFont(.b1Sb18, text: "나이와 간단한 소개를 적어볼까요?")
        }
        
        descriptionTextView.do {
            $0.updatePlaceholder(isHidden: false)
            $0.clearButton.isHidden = true
            $0.setPlaceholderTruncation(numberOfLines: 3)
            $0.textView.isScrollEnabled = false
        }
        
        kakaoLinkTitleLabel.do {
            $0.setFont(.b1Sb18, text: "카카오톡 오픈채팅 링크")
        }
        
        kakaoLinkTextView.do {
            $0.updatePlaceholder(isHidden: false)
            $0.clearButton.isHidden = true
            $0.setPlaceholderTruncation(numberOfLines: 1)
        }

        updateCompleteButtonState()
    }

    override func setUI() {
        addSubviews(navigationBar, scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            whenTitleLabel, buttonStackView, datePicker,
            peopleTopDivider, peopleTitleLabel, peopleStepper,
            peopleNumber, peopleButton, peopleExplainLabel,
            peopleBottomDivider, tagTitleLabel, tagCollectionView,
            tagBottomDivider, meetingPlaceTitleLabel, meetingPlaceTextView,
            descriptionTitleLabel, descriptionTextView, kakaoLinkTitleLabel,
            kakaoLinkTextView, completeButton
        )
        buttonStackView.addArrangedSubviews(nowButton, timeButton)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

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
            $0.height.equalTo(138)
        }

        peopleTopDivider.snp.makeConstraints {
            $0.bottom.equalTo(peopleTitleLabel.snp.top).offset(-24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        peopleTitleLabel.snp.makeConstraints {
            peopleTitleTopFromButtonConstraint = $0.top.equalTo(buttonStackView.snp.bottom).offset(40).constraint
            peopleTitleTopFromDatePickerConstraint = $0.top.equalTo(datePicker.snp.bottom).offset(40).constraint
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

        peopleExplainLabel.snp.makeConstraints {
            peopleCheckBoxTopFromTitleConstraint = $0.top.equalTo(peopleTitleLabel.snp.bottom).offset(18.5).constraint
            peopleCheckBoxTopFromStepperConstraint = $0.top.equalTo(peopleStepper.snp.bottom).offset(25.5).constraint
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(22)
        }

        peopleBottomDivider.snp.makeConstraints {
            $0.top.equalTo(peopleExplainLabel.snp.bottom).offset(31)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }

        peopleCheckBoxTopFromStepperConstraint?.deactivate()
        
        tagTitleLabel.snp.makeConstraints {
            $0.top.equalTo(peopleBottomDivider.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(tagTitleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(124)
        }
        
        tagBottomDivider.snp.makeConstraints {
            $0.top.equalTo(tagCollectionView.snp.bottom).offset(31)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        meetingPlaceTitleLabel.snp.makeConstraints {
            $0.top.equalTo(tagBottomDivider.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        meetingPlaceTextView.snp.makeConstraints {
            $0.top.equalTo(meetingPlaceTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        descriptionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(meetingPlaceTextView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(descriptionTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            descriptionTextViewHeightConstraint = $0.height
                .equalTo(descriptionTextViewMinimumHeight)
                .constraint
        }
        
        kakaoLinkTitleLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionTextView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        kakaoLinkTextView.snp.makeConstraints {
            $0.top.equalTo(kakaoLinkTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        completeButton.snp.makeConstraints {
            $0.top.equalTo(kakaoLinkTextView.snp.bottom).offset(28)
            $0.bottom.equalToSuperview().inset(21)
            $0.height.equalTo(56)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }

    override func registerCells() {
        tagCollectionView.register(NearbyTextChipCollectionViewCell.self)
    }

    override func setAddTarget() {
        nowButton.addTarget(self, action: #selector(nowButtonDidTap), for: .touchUpInside)
        timeButton.addTarget(self, action: #selector(timeButtonDidTap), for: .touchUpInside)
        peopleButton.addTarget(self, action: #selector(peopleButtonDidTap), for: .touchUpInside)
        meetingPlaceTextView.textView.delegate = self
        descriptionTextView.textView.delegate = self
        kakaoLinkTextView.textView.delegate = self
        peopleStepper.countDidChange = { [weak self] count in
            self?.peopleNumber.text = "\(count)명"
        }
        meetingPlaceTextView.clearButton.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
    }

    // MARK: - Methods
    
    private func makeTagLayout() -> UICollectionViewFlowLayout {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        return layout
    }

    private func tagChipStyle(at index: Int) -> NearbyChipStyle {
        return selectedTagIndexes.contains(index) ? .tagStateSelected : .tagStateUnselected
    }

    private func updateDescriptionTextViewHeight() {
        let textView = descriptionTextView.textView
        let fittingSize = CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude)
        let textHeight = textView.sizeThatFits(fittingSize).height
        let containerHeight = max(descriptionTextViewMinimumHeight, ceil(textHeight) + 32)

        descriptionTextViewHeightConstraint?.update(offset: containerHeight)

        UIView.performWithoutAnimation {
            layoutIfNeeded()
        }
    }

    private func hasText(_ textView: NearbyTextView) -> Bool {
        let text = textView.textView.text ?? ""

        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func updateCompleteButtonState() {
        let isEnabled = hasText(meetingPlaceTextView)
            && hasText(descriptionTextView)
            && hasText(kakaoLinkTextView)

        completeButton.isEnabled = isEnabled
        completeButton.backgroundColor = isEnabled ? .btnPrimaryBg : .grey10
        completeButton.setTitleColor(isEnabled ? .white : .grey40, for: .normal)
    }
    
    // MARK: - Actions

    @objc
    private func nowButtonDidTap() {
        nowButton.setSelected(true)
        timeButton.setSelected(false)
        datePicker.isHidden = true
        peopleTitleTopFromDatePickerConstraint?.deactivate()
        peopleTitleTopFromButtonConstraint?.activate()
    }

    @objc
    private func timeButtonDidTap() {
        nowButton.setSelected(false)
        timeButton.setSelected(true)
        datePicker.isHidden = false
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
    
    @objc
    private func searchButtonDidTap() {
        // TODO: - 장소 검색 API 연결
    }

    @objc
    private func completeButtonDidTap() {
        // TODO: - 다음 뷰 연결
    }
}

// MARK: - UICollectionViewDataSource

extension RecruitCompanionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagTitles.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(NearbyTextChipCollectionViewCell.self, for: indexPath)
        let title = tagTitles[indexPath.item]
        
        cell.configure(style: tagChipStyle(at: indexPath.item), title: title, horizontalInset: 12)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RecruitCompanionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let title = tagTitles[indexPath.item]
        let font = NearbyChipStyle.tagStateUnselected.font
        let titleWidth = (title as NSString).size(withAttributes: [.font: font]).width
        let horizontalInset: CGFloat = 24

        return CGSize(
            width: ceil(titleWidth + horizontalInset),
            height: NearbyChipStyle.tagStateUnselected.height
        )
    }
}

// MARK: - UICollectionViewDelegate

extension RecruitCompanionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedTagIndexes.contains(indexPath.item) {
            selectedTagIndexes.remove(indexPath.item)
        } else {
            selectedTagIndexes.insert(indexPath.item)
        }

        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [indexPath])
            collectionView.layoutIfNeeded()
        }
    }
}

// MARK: - UITextViewDelegate

extension RecruitCompanionView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let shouldHidePlaceholder = !textView.text.isEmpty

        if textView == meetingPlaceTextView.textView {
            meetingPlaceTextView.updatePlaceholder(isHidden: shouldHidePlaceholder)
        } else if textView == descriptionTextView.textView {
            descriptionTextView.updatePlaceholder(isHidden: shouldHidePlaceholder)
            updateDescriptionTextViewHeight()
        } else if textView == kakaoLinkTextView.textView {
            kakaoLinkTextView.updatePlaceholder(isHidden: shouldHidePlaceholder)
        }

        updateCompleteButtonState()
    }
}

final class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = (super.layoutAttributesForElements(in: rect) ?? []).compactMap {
            $0.copy() as? UICollectionViewLayoutAttributes
        }
        let cellAttributes = attributes
            .filter { $0.representedElementCategory == .cell }
            .sorted { $0.indexPath.item < $1.indexPath.item }
        var leftMargin: CGFloat = 0.0
        var maxY: CGFloat = -1.0
    
        cellAttributes.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = 0.0
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}
