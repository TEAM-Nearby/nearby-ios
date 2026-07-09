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
    
    private var firstSelectedTagIndexes = Set<Int>()
    private var secondSelectedTagIndexes = Set<Int>()
    
    var onRatingChanged: ((Int) -> Void)?
    var onTagsChanged: ((Set<Int>, Set<Int>) -> Void)?
    var onReportButtonDidTap: (() -> Void)?
    var onCompletionButtonDidTap: (() -> Void)?
    
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
    private let firstTagTitles = [
        "연락이 빨라요", "매너가 좋아요", "대화가 잘 통해요",
        "입담이 좋아요", "유용한 정보를 많이 알아요"
    ]
    private lazy var firstTagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeTagLayout())
    
    private let secondCategoryLabel = UILabel()
    private let secondTagTitles = [
        "시간 약속을 잘 지켜요", "늦어도 미리 알려줘요",
        "약속 시간보다 일찍 와요"
    ]
    private lazy var secondTagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeTagLayout())
    
    private let reportView = UIView()
    private let reportLabelStackView = UIStackView()
    private let reportTitleLabel = UILabel()
    private let reportSubtitleLabel = UILabel()
    private let reportButton = UIButton()
    
    private let completionButton = NearbyButton(style: .primary, title: "")
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .bgSurfaceGrey0
        
        navigationBar.do {
            $0.configure(leftItem: .back, centerItem: .title("동행 후기"))
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
        }
        
        reviewTitleLabel.do {
            $0.setFont(.b1Sb18, text: "어떤 점이 좋았나요?", textColor: .grey80)
            $0.textAlignment = .left
            $0.numberOfLines = 2
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
        
        reportView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
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
            $0.titleLabel?.setFont(.c1M12, text: "신고하기", textColor: .highlightRed)
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
        reviewView.addSubviews(reviewTitleLabel, reviewSubtitleLabel,
                               firstCategoryLabel, firstTagCollectionView,
                               secondCategoryLabel, secondTagCollectionView)
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
            $0.height.equalTo(80)
        }
        
        secondCategoryLabel.snp.makeConstraints {
            $0.top.equalTo(firstTagCollectionView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(12)
        }
        
        secondTagCollectionView.snp.makeConstraints {
            $0.top.equalTo(secondCategoryLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(80)
            $0.bottom.equalToSuperview().inset(16)
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
        reportButton.addTarget(self, action: #selector(reportButtonDidTap), for: .touchUpInside)
        completionButton.addTarget(self, action: #selector(completionButtonDidTap), for: .touchUpInside)
    }
    
    override func registerCells() {
        firstTagCollectionView.register(NearbyTextChipCollectionViewCell.self)
        secondTagCollectionView.register(NearbyTextChipCollectionViewCell.self)
    }
    
    // MARK: - Methods
    
    private func makeTagLayout() -> UICollectionViewFlowLayout {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        return layout
    }

    private func tagTitles(for collectionView: UICollectionView) -> [String] {
        collectionView === firstTagCollectionView ? firstTagTitles : secondTagTitles
    }

    private func selectedIndexes(for collectionView: UICollectionView) -> Set<Int> {
        collectionView === firstTagCollectionView ? firstSelectedTagIndexes : secondSelectedTagIndexes
    }
    
    func updateCompletionButton(isEnabled: Bool) {
        completionButton.isEnabled = isEnabled
    }

    func setCompletionButtonTitle(_ title: String) {
        completionButton.setTitle(title, for: .normal)
    }
    
    func configure(name: String, information: String) {
        profileTitleLabel.text = "\(name) 님과의 여행이\n끝났어요."
        informationLabel.text = information
        reviewSubtitleLabel.text = "\(name) 님에게 좋았던 점을 남겨보세요."
    }
    
    // MARK: - Action
    
    @objc
    private func reportButtonDidTap() {
        onReportButtonDidTap?()
    }
    
    @objc
    private func completionButtonDidTap() {
        onCompletionButtonDidTap?()
    }
}

// MARK: - UICollectionViewDataSource

extension ReviewPostView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        tagTitles(for: collectionView).count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NearbyTextChipCollectionViewCell = collectionView.dequeueReusableCell(NearbyTextChipCollectionViewCell.self, for: indexPath)
        let titles = tagTitles(for: collectionView)
        let isSelected = selectedIndexes(for: collectionView).contains(indexPath.item)
        let style: NearbyChipStyle = isSelected ? .tagStateSelected : .tagStateUnselected
        
        cell.configure(style: style, title: titles[indexPath.item], horizontalInset: 12)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ReviewPostView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = tagTitles(for: collectionView)[indexPath.item]
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

extension ReviewPostView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if collectionView === firstTagCollectionView {
            toggle(&firstSelectedTagIndexes, at: indexPath.item)
        } else {
            toggle(&secondSelectedTagIndexes, at: indexPath.item)
        }
        
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [indexPath])
            collectionView.layoutIfNeeded()
            onTagsChanged?(firstSelectedTagIndexes, secondSelectedTagIndexes)
        }
    }
    
    private func toggle(_ set: inout Set<Int>, at index: Int) {
        if set.contains(index) {
            set.remove(index)
        } else {
            set.insert(index)
        }
    }
}
