//
//  NearCompanionCell.swift
//  Nearby
//
//  Created by soomin on 7/8/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class NearCompanionCell: UICollectionViewCell {

    // MARK: - Properties

    override var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted && !isShowingSkeleton ? .bgSurfacePurple : .white
        }
    }

    private let profileAvatarCount = 4
    private var isShowingSkeleton = false

    // MARK: - UI Components

    private let dividerView = UIView()
    private let placeImageView = UIImageView()
    private let placeNameLabel = UILabel()
    private let timeLabel = UILabel()

    private let contentLabel = UILabel()
    private let timeStackView = UIStackView()
    private let clockIcon = UIImageView()
    private let scheduleLabel = UILabel()

    private let profileStackView = AvatarStackView()
    private let peopleStackView = UIStackView()
    private let overflowCountLabel = UILabel()
    private let currentStatusLabel = UILabel()
    private let arrowIcon = UIImageView()

    private let skeletonContainerView = SkeletonShimmerContainerView()
    private let skeletonImageView = SkeletonShimmerView(cornerRadius: 16)
    private let skeletonTitleView = SkeletonShimmerView(cornerRadius: 8)
    private let skeletonContentView = SkeletonShimmerView(cornerRadius: 10)
    private let skeletonScheduleView = SkeletonShimmerView(cornerRadius: 8)
    private let skeletonProfileView = SkeletonShimmerView(cornerRadius: 8)
    private let skeletonProfileSecondView = SkeletonShimmerView(cornerRadius: 8)
    private let skeletonStatusView = SkeletonShimmerView(cornerRadius: 8)

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func prepareForReuse() {
        super.prepareForReuse()
        placeImageView.kf.cancelDownloadTask()
        placeImageView.image = nil
        setSkeletonVisible(false)
    }

    // MARK: - Methods

    private func setStyle() {
        contentView.backgroundColor = .white

        dividerView.do {
            $0.backgroundColor = .grey5
        }

        placeImageView.do {
            $0.backgroundColor = .grey5
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 16
        }

        placeNameLabel.do {
            $0.setFont(.b2M16, textColor: .grey80)
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }

        timeLabel.do {
            $0.setFont(.c1R12, textColor: .grey30)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        contentLabel.do {
            $0.setFont(.c1M12, textColor: .grey70)
            $0.numberOfLines = 2
            $0.lineBreakMode = .byTruncatingTail
        }

        timeStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
        }

        clockIcon.do {
            $0.image = .clockIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .chipIcOrange
        }

        peopleStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
            $0.alignment = .center
        }

        overflowCountLabel.do {
            $0.setFont(.b2M16, textColor: .grey40)
            $0.isHidden = true
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        scheduleLabel.do {
            $0.setFont(.c1R12, textColor: .grey70)
        }

        currentStatusLabel.do {
            $0.setFont(.c1M12, textColor: .highlightTextPurple)
        }

        arrowIcon.do {
            $0.image = .chevronRightIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .grey40
        }

        skeletonContainerView.do {
            $0.backgroundColor = .white
            $0.isHidden = true
            $0.isUserInteractionEnabled = false
            $0.accessibilityElementsHidden = true
        }
    }

    private func setUI() {
        contentView.addSubviews(dividerView, placeImageView, placeNameLabel, timeLabel, contentLabel,
                                timeStackView, peopleStackView, arrowIcon)
        timeStackView.addArrangedSubviews(clockIcon, scheduleLabel)
        peopleStackView.addArrangedSubviews(profileStackView, overflowCountLabel, currentStatusLabel)

        contentView.addSubview(skeletonContainerView)
        skeletonContainerView.addSubviews(skeletonImageView, skeletonTitleView, skeletonContentView, skeletonScheduleView,
                                          skeletonProfileView, skeletonProfileSecondView, skeletonStatusView)
    }

    private func setLayout() {
        dividerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }

        placeImageView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(130)
            $0.height.equalTo(140)
            $0.bottom.lessThanOrEqualToSuperview().inset(16)
        }

        placeNameLabel.snp.makeConstraints {
            $0.top.equalTo(placeImageView).offset(14)
            $0.leading.equalTo(placeImageView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualTo(timeLabel.snp.leading).offset(-8)
        }

        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(placeNameLabel)
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(12)
            $0.leading.equalTo(placeNameLabel)
            $0.trailing.equalTo(timeLabel)
        }

        timeStackView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(10)
            $0.leading.equalTo(contentLabel).offset(4)
        }

        clockIcon.snp.makeConstraints {
            $0.size.equalTo(16)
        }

        peopleStackView.snp.makeConstraints {
            $0.top.equalTo(timeStackView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(25)
            $0.leading.equalTo(contentLabel.snp.leading).offset(3)
        }

        arrowIcon.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(profileStackView)
        }

        skeletonContainerView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        skeletonImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(130)
            $0.height.equalTo(140)
            $0.bottom.lessThanOrEqualToSuperview().inset(16)
        }

        skeletonTitleView.snp.makeConstraints {
            $0.top.equalTo(skeletonImageView)
            $0.leading.equalTo(skeletonImageView.snp.trailing).offset(12)
            $0.width.equalTo(138)
            $0.height.equalTo(28)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
        }

        skeletonContentView.snp.makeConstraints {
            $0.top.equalTo(skeletonTitleView.snp.bottom).offset(8)
            $0.leading.equalTo(skeletonTitleView)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(47)
        }

        skeletonScheduleView.snp.makeConstraints {
            $0.top.equalTo(skeletonContentView.snp.bottom).offset(6)
            $0.leading.trailing.equalTo(skeletonContentView)
            $0.height.equalTo(15)
        }

        skeletonProfileView.snp.makeConstraints {
            $0.top.equalTo(skeletonScheduleView.snp.bottom).offset(6)
            $0.leading.equalTo(skeletonScheduleView).offset(4)
            $0.size.equalTo(16)
        }

        skeletonProfileSecondView.snp.makeConstraints {
            $0.leading.equalTo(skeletonProfileView.snp.trailing).offset(-4)
            $0.centerY.equalTo(skeletonProfileView)
            $0.size.equalTo(16)
        }

        skeletonStatusView.snp.makeConstraints {
            $0.leading.equalTo(skeletonProfileSecondView.snp.trailing).offset(8)
            $0.trailing.equalTo(skeletonScheduleView)
            $0.centerY.equalTo(skeletonProfileView)
            $0.height.equalTo(16)
        }
    }

    private func configureOverflowCount(_ participantCount: Int) {
        let overflowCount = max(participantCount - profileAvatarCount, 0)
        overflowCountLabel.text = overflowCount > 0 ? "+\(overflowCount)" : nil
        overflowCountLabel.isHidden = overflowCount == 0

        peopleStackView.setCustomSpacing(overflowCount > 0 ? 0 : 6, after: profileStackView)
        peopleStackView.setCustomSpacing(6, after: overflowCountLabel)
    }

    private func setSkeletonVisible(_ isVisible: Bool) {
        isShowingSkeleton = isVisible
        skeletonContainerView.isHidden = !isVisible
        isUserInteractionEnabled = !isVisible
        accessibilityElementsHidden = isVisible
    }

    func configure(with item: NearCompanionCellItem) {
        setSkeletonVisible(false)
        placeImageView.image = item.placeImage

        if let placeImageURL = item.placeImageURL {
            placeImageView.kf.setImage(with: placeImageURL, placeholder: item.placeImage)
        }

        placeNameLabel.text = item.placeName
        timeLabel.text = item.writtenTime
        contentLabel.setFont(.c1M12, text: item.content, textColor: .grey70, lineSpacing: 3)
        scheduleLabel.text = item.schedule
        profileStackView.configure(withImageURLs: Array( item.participantImageURLs.prefix(profileAvatarCount)))
        configureOverflowCount(item.detailState.participantCount)
        currentStatusLabel.text = item.statusText
    }

    func configureSkeleton() {
        placeImageView.kf.cancelDownloadTask()
        placeImageView.image = nil
        setSkeletonVisible(true)
    }
}
