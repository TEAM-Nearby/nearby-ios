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
    private let peopleStepper = NearbyStepper()
    private let peopleNumber = UILabel()
    private let peopleTitleLabel = UILabel()
    private let peopleCheckBox = NearbyCheckBox(text: "목표 인원이 안 차도 출발할래요")
    private let peopleButton = UIButton()
    private let peopleTopDivider = UIView()
    private let peopleBottomDivider = UIView()
    private let tagTitleLabel = UILabel()
    private let tagTitles = ["사진에 진심인", "리액션이 좋은", "차분한 성격", "정보 공유 환영", "새로운 음식 도전", "음식 쉐어 가능", "파워 J형", "파워 P형", "술 한잔 가능"]
    private lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeTagLayout())
    private let tagBottomDivider = UIView()
    
    // MARK: - Properties

    private var peopleTitleTopFromButtonConstraint: Constraint?
    private var peopleTitleTopFromDatePickerConstraint: Constraint?
    private var peopleCheckBoxTopFromTitleConstraint: Constraint?
    private var peopleCheckBoxTopFromStepperConstraint: Constraint?
    private var selectedTagIndexes = Set<Int>()
    
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
        
        peopleTitleLabel.do {
            $0.text = "최대 몇 명과 함께 갈까요?"
            $0.font = NearbyFont.b1Sb18.font
            $0.textColor = .grey80
        }
        
        peopleNumber.do {
            $0.text = "2명"
            $0.font = NearbyFont.h3Sb20.font
            $0.textColor = .primary50
        }

        peopleStepper.isHidden = true

        [peopleTopDivider, peopleBottomDivider, tagBottomDivider].forEach {
            $0.backgroundColor = .grey5
        }
        
        peopleButton.setImage(.chevronDownIcon, for: .normal)
        peopleButton.setImage(.chevronUpIcon, for: .selected)
        
        tagTitleLabel.do {
            $0.text = "어떤 동행과 함께하고 싶나요?"
            $0.font = NearbyFont.b1Sb18.font
            $0.textColor = .grey80
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
            whenTitleLabel,
            buttonStackView,
            datePicker,
            peopleTopDivider,
            peopleTitleLabel,
            peopleStepper,
            peopleNumber,
            peopleButton,
            peopleCheckBox,
            peopleBottomDivider,
            tagTitleLabel,
            tagCollectionView,
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

        peopleCheckBox.snp.makeConstraints {
            peopleCheckBoxTopFromTitleConstraint = $0.top.equalTo(peopleTitleLabel.snp.bottom).offset(18.5).constraint
            peopleCheckBoxTopFromStepperConstraint = $0.top.equalTo(peopleStepper.snp.bottom).offset(25.5).constraint
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(22)
        }

        peopleBottomDivider.snp.makeConstraints {
            $0.top.equalTo(peopleCheckBox.snp.bottom).offset(31)
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
            $0.width.equalTo(353)
            $0.height.equalTo(124)
            $0.leading.equalToSuperview().inset(20)
        }
        
        tagBottomDivider.snp.makeConstraints {
            $0.top.equalTo(tagCollectionView.snp.bottom).offset(31)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    override func registerCells() {
        setAction()
        tagCollectionView.register(NearbyTextChipCollectionViewCell.self)
    }

    // MARK: - Method
    
    private func setAction() {
        nowButton.addTarget(self, action: #selector(nowButtonDidTap), for: .touchUpInside)
        timeButton.addTarget(self, action: #selector(timeButtonDidTap), for: .touchUpInside)
        peopleButton.addTarget(self, action: #selector(peopleButtonDidTap), for: .touchUpInside)
        peopleStepper.countDidChange = { [weak self] count in
            self?.peopleNumber.text = "\(count)명"
        }
    }
    
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
    
    // MARK: - Action

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
}

extension RecruitCompanionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagTitles.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            NearbyTextChipCollectionViewCell.self,
            for: indexPath
        )
        let title = tagTitles[indexPath.item]
        
        cell.configure(style: tagChipStyle(at: indexPath.item), title: title, horizontalInset: 12)

        return cell
    }
}

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

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)?.compactMap {
            $0.copy() as? UICollectionViewLayoutAttributes
        }
        let cellAttributes = attributes?
            .filter { $0.representedElementCategory == .cell }
            .sorted { $0.indexPath.item < $1.indexPath.item }
        var leftMargin: CGFloat = 0.0
        var maxY: CGFloat = -1.0
    
        cellAttributes?.forEach { layoutAttribute in
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
