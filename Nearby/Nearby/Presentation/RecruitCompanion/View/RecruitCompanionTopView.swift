//
//  RecruitCompanionTopView.swift
//  Nearby
//
//  Created by 장지인 on 7/10/26.
//

import UIKit

import SnapKit
import Then

final class RecruitCompanionTopView: BaseView {
    
    // MARK: - UI Components

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
    private let styleKeywords = RecruitCompanionStyleKeyword.allCases
    private lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeTagLayout())
    private let tagBottomDivider = UIView()
    
    // MARK: - Properties

    private var peopleTitleTopFromButtonConstraint: Constraint?
    private var peopleTitleTopFromDatePickerConstraint: Constraint?
    private var peopleExplainTopFromTitleConstraint: Constraint?
    private var peopleExplainTopFromStepperConstraint: Constraint?
    private var selectedTagIndexes = Set<Int>()

    var timeTypeDidSelect: ((RecruitMeetingTimeType) -> Void)?
    var meetingAtDidChange: ((Date) -> Void)?
    var participantCountDidChange: ((Int) -> Void)?
    var styleKeywordDidTap: ((RecruitCompanionStyleKeyword) -> Void)?
    
    // MARK: - Custom Methods
    
    override func setStyle() {
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
    }

    override func setUI() {
        addSubviews(
            whenTitleLabel, buttonStackView, datePicker,
            peopleTopDivider, peopleTitleLabel, peopleStepper,
            peopleNumber, peopleButton, peopleExplainLabel,
            peopleBottomDivider, tagTitleLabel, tagCollectionView,
            tagBottomDivider
        )
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
            peopleExplainTopFromTitleConstraint = $0.top.equalTo(peopleTitleLabel.snp.bottom).offset(18.5).constraint
            peopleExplainTopFromStepperConstraint = $0.top.equalTo(peopleStepper.snp.bottom).offset(25.5).constraint
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(22)
        }

        peopleBottomDivider.snp.makeConstraints {
            $0.top.equalTo(peopleExplainLabel.snp.bottom).offset(31)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }

        peopleExplainTopFromStepperConstraint?.deactivate()
        
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
            $0.bottom.equalToSuperview()
        }
    }

    override func registerCells() {
        tagCollectionView.register(NearbyTextChipCollectionViewCell.self)
    }

    override func setAddTarget() {
        nowButton.addTarget(self, action: #selector(nowButtonDidTap), for: .touchUpInside)
        timeButton.addTarget(self, action: #selector(timeButtonDidTap), for: .touchUpInside)
        peopleButton.addTarget(self, action: #selector(peopleButtonDidTap), for: .touchUpInside)

        datePicker.dateDidChange = { [weak self] date in
            self?.meetingAtDidChange?(date)
        }
        
        peopleStepper.countDidChange = { [weak self] count in
            self?.participantCountDidChange?(count)
        }
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

    func update(state: RecruitCompanionViewModel.State) {
        let isNow = state.meetingTimeType == .now
        nowButton.setSelected(isNow)
        timeButton.setSelected(!isNow)
        datePicker.isHidden = !state.isDatePickerVisible
        peopleNumber.text = "\(state.maxParticipants)명"

        if state.isDatePickerVisible {
            peopleTitleTopFromButtonConstraint?.deactivate()
            peopleTitleTopFromDatePickerConstraint?.activate()
        } else {
            peopleTitleTopFromDatePickerConstraint?.deactivate()
            peopleTitleTopFromButtonConstraint?.activate()
        }

        selectedTagIndexes = Set(
            styleKeywords.indices.filter { state.styleKeywords.contains(styleKeywords[$0]) }
        )
        tagCollectionView.reloadData()
    }
    
    // MARK: - Actions

    @objc
    private func nowButtonDidTap() {
        timeTypeDidSelect?(.now)
    }

    @objc
    private func timeButtonDidTap() {
        timeTypeDidSelect?(.scheduled)
        meetingAtDidChange?(datePicker.selectedDate)
    }

    @objc
    private func peopleButtonDidTap() {
        peopleButton.isSelected.toggle()
        peopleStepper.isHidden = !peopleButton.isSelected

        if peopleButton.isSelected {
            peopleExplainTopFromTitleConstraint?.deactivate()
            peopleExplainTopFromStepperConstraint?.activate()
        } else {
            peopleExplainTopFromStepperConstraint?.deactivate()
            peopleExplainTopFromTitleConstraint?.activate()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension RecruitCompanionTopView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return styleKeywords.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(NearbyTextChipCollectionViewCell.self, for: indexPath)
        let title = styleKeywords[indexPath.item].title
        
        cell.configure(style: tagChipStyle(at: indexPath.item), title: title, horizontalInset: 12)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RecruitCompanionTopView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = styleKeywords[indexPath.item].title
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

extension RecruitCompanionTopView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        styleKeywordDidTap?(styleKeywords[indexPath.item])
    }
}
