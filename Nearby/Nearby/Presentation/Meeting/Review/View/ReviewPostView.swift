//
//  ReviewPostView.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import UIKit

import SnapKit
import Then

final class ReviewPostView: BaseView {
    
    // MARK: - Properties
    
    var onBackButtonDidTap: (() -> Void)?
    var onRatingChanged: ((Int) -> Void)?
    var onReportButtonDidTap: (() -> Void)?
    var onCompletionButtonDidTap: (() -> Void)?
    
    private var firstTagHeightConstraint: Constraint?
    private var secondTagHeightConstraint: Constraint?
    
    // MARK: - UI Components
    
    private let navigationBar = NearbyNavigationBar()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let profileView = UIStackView()
    private let profileImageView = GradientCircleView(diameter: 80)
    private let profileLabelStackView = UIStackView()
    private let profileTitleLabel = UILabel()
    private let informationLabel = UILabel()
    
    private let starView = UIView()
    private let starTitleLabel = UILabel()
    private let starRating = StarRatingInputView()
    
    private let reviewView = UIView()
    private let reviewTitleLabel = UILabel()
    private let reviewSubtitleLabel = UILabel()
    
    private let firstCategoryLabel = UILabel()
    let firstTagCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ReviewPostView.makeTagLayout()
    )
    
    private let secondCategoryLabel = UILabel()
    let secondTagCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ReviewPostView.makeTagLayout()
    )
    
    private let reportView = UIView()
    private let reportLabelStackView = UIStackView()
    private let reportTitleLabel = UILabel()
    private let reportSubtitleLabel = UILabel()
    private let reportButton = UIButton()
    
    private let completionButton = NearbyButton(style: .primary, title: "")
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        firstTagCollectionView.layoutIfNeeded()
        secondTagCollectionView.layoutIfNeeded()
        
        let firstHeight = firstTagCollectionView.contentSize.height
        let secondHeight = secondTagCollectionView.contentSize.height
        
        if firstTagCollectionView.bounds.height != firstHeight {
            firstTagHeightConstraint?.update(offset: firstHeight)
        }
        if secondTagCollectionView.bounds.height != secondHeight {
            secondTagHeightConstraint?.update(offset: secondHeight)
        }
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        navigationBar.do {
            $0.configure(leftItem: .back, centerItem: .title("동행 후기"))
            $0.backgroundColor = .clear
        }
        
        scrollView.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
        }
        
        contentView.do {
            $0.backgroundColor = .clear
        }
        
        profileView.do {
            $0.axis = .horizontal
            $0.spacing = 28
        }
        
        profileLabelStackView.do {
            $0.axis = .vertical
            $0.spacing = 6
        }
        
        profileTitleLabel.do {
            $0.setFont(.h3Sb20, text: "", textColor: .grey90)
            $0.textAlignment = .left
            $0.numberOfLines = 2
        }
        
        informationLabel.do {
            $0.setFont(.b3M14, text: "", textColor: .grey60)
        }
        
        starView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
        }
        
        starTitleLabel.do {
            $0.setFont(.b1Sb18, text: "이번 동행은 어떠셨나요?", textColor: .grey80)
            $0.textAlignment = .left
        }
        
        reviewView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }
        
        reviewTitleLabel.do {
            $0.setFont(.b1Sb18, text: "어떤 점이 좋았나요?", textColor: .grey80)
            $0.textAlignment = .left
        }
        
        reviewSubtitleLabel.do {
            $0.setFont(.b3M14, text: "", textColor: .grey40)
            $0.textAlignment = .left
        }
        
        firstCategoryLabel.do {
            $0.setFont(.b2M16, text: "배려 · 소통", textColor: .grey80)
            $0.textAlignment = .left
        }
        
        secondCategoryLabel.do {
            $0.setFont(.b2M16, text: "시간 약속", textColor: .grey80)
            $0.textAlignment = .left
        }
        
        firstTagCollectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
        }
        
        secondTagCollectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
        }
        
        reportView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }
        
        reportLabelStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
        }
        
        reportTitleLabel.do {
            $0.setFont(.b2M16, text: "동행에서 불편한 일이 있었나요?", textColor: .grey80)
            $0.textAlignment = .left
        }
        
        reportSubtitleLabel.do {
            $0.setFont(.b3M14, text: "*상대방에게는 절대 보이지 않아요.", textColor: .grey40)
            $0.textAlignment = .left
        }
        
        reportButton.do {
            $0.setTitle("신고하기", for: .normal)
            $0.setTitleColor(.highlightRed, for: .normal)
            $0.titleLabel?.font = NearbyFont.c1M12.font
            $0.setUnderline()
        }
    }
    
    override func setUI() {
        addSubviews(navigationBar, scrollView, completionButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(profileView, starView, reviewView, reportView)
        profileView.addArrangedSubviews(profileImageView, profileLabelStackView)
        profileLabelStackView.addArrangedSubviews(profileTitleLabel, informationLabel)
        starView.addSubviews(starTitleLabel, starRating)
        reviewView.addSubviews(reviewTitleLabel, reviewSubtitleLabel, firstCategoryLabel, firstTagCollectionView, secondCategoryLabel, secondTagCollectionView)
        reportView.addSubviews(reportLabelStackView, reportButton)
        reportLabelStackView.addArrangedSubviews(reportTitleLabel, reportSubtitleLabel)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(completionButton.snp.top).offset(-12)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        profileView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        starView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        starTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(12)
        }
        
        starRating.snp.makeConstraints {
            $0.top.equalTo(starTitleLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        reviewView.snp.makeConstraints {
            $0.top.equalTo(starView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        reviewTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(12)
        }
        
        reviewSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(reviewTitleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(12)
        }
        
        firstCategoryLabel.snp.makeConstraints {
            $0.top.equalTo(reviewSubtitleLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(12)
        }
        
        firstTagCollectionView.snp.makeConstraints {
            $0.top.equalTo(firstCategoryLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(12)
            firstTagHeightConstraint = $0.height.equalTo(0).constraint
        }
        
        secondCategoryLabel.snp.makeConstraints {
            $0.top.equalTo(firstTagCollectionView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(12)
        }
        
        secondTagCollectionView.snp.makeConstraints {
            $0.top.equalTo(secondCategoryLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(16)
            secondTagHeightConstraint = $0.height.equalTo(0).constraint
        }
        
        reportView.snp.makeConstraints {
            $0.top.equalTo(reviewView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        reportLabelStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().inset(25)
        }
        
        reportButton.snp.makeConstraints {
            $0.centerY.equalTo(reportLabelStackView.snp.centerY)
            $0.trailing.equalToSuperview().inset(25)
        }
        
        completionButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
    }
    
    override func setAddTarget() {
        navigationBar.leftButtonAction = { [weak self] in
            self?.onBackButtonDidTap?()
        }
        starRating.onRatingChanged = { [weak self] rating in
            self?.onRatingChanged?(rating)
        }
        reportButton.addTarget(self, action: #selector(reportButtonDidTap), for: .touchUpInside)
        completionButton.addTarget(self, action: #selector(completionButtonDidTap), for: .touchUpInside)
    }
    
    override func registerCells() {
        firstTagCollectionView.register(NearbyTextChipCollectionViewCell.self)
        secondTagCollectionView.register(NearbyTextChipCollectionViewCell.self)
    }
    
    // MARK: - Methods
    
    private static func makeTagLayout() -> UICollectionViewFlowLayout {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        return layout
    }
    
    func configure(name: String, information: String, buttonTitle: String) {
        profileTitleLabel.text = "\(name) 님과의 여행이\n끝났어요."
        informationLabel.text = information
        reviewSubtitleLabel.text = "\(name) 님에게 좋았던 점을 남겨보세요."
        completionButton.setTitle(buttonTitle, for: .normal)
    }
    
    func updateCompletionButton(isEnabled: Bool) {
        completionButton.isEnabled = isEnabled
    }
    
    // MARK: - Actions
    
    @objc
    private func reportButtonDidTap() {
        onReportButtonDidTap?()
    }
    
    @objc
    private func completionButtonDidTap() {
        onCompletionButtonDidTap?()
    }
}
