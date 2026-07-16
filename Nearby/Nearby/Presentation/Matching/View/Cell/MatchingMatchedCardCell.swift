//
//  MatchingMatchedCardCell.swift
//  Nearby
//
//  Created by 장지인 on 7/9/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class MatchingMatchedCardCell: UICollectionViewCell {

    // MARK: - Properties

    var onNextButtonDidTap: (() -> Void)?

    private enum Metric {
        static let horizontalInset: CGFloat = 20
        static let verticalInset: CGFloat = 16
        static let profileSize: CGFloat = 40
        static let titleHeight: CGFloat = 22
        static let informationTopOffset: CGFloat = 4
        static let informationHeight: CGFloat = 20
        static let contentTopOffset: CGFloat = 12
        static let contentHeight: CGFloat = 20
    }

    // MARK: - UI Components

    private let profileContainerView = UIView()
    private let profileImageView = UIImageView()
    private let profileClusterView = AvatarClusterView()
    private let nameLabel = UILabel()
    private let genderLabel = UILabel()
    private let uploadedTimeLabel = UILabel()
    private let informationStackView = UIStackView()
    private let placeLabel = UILabel()
    private let informationDotLabel = UILabel()
    private let meetingTimeLabel = UILabel()
    private let contentLabel = UILabel()
    private let nextButton = UIButton()
    private let dotLabel = UILabel()
    private var informationTrailingToButtonConstraint: Constraint?
    private var informationTrailingToSuperviewConstraint: Constraint?

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
        setUI()
        setLayout()
        setAddTarget()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        updateProfileImageCornerRadius()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        profileImageView.kf.cancelDownloadTask()
        profileImageView.image = .imgProfileDefault
        updateProfileImageCornerRadius()
        profileClusterView.reset()
        onNextButtonDidTap = nil
    }

    // MARK: - Methods

    private func setStyle() {
        contentView.do {
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }

        profileContainerView.do {
            $0.layer.cornerRadius = Metric.profileSize / 2
            $0.layer.masksToBounds = true
            $0.clipsToBounds = true
        }

        profileImageView.do {
            $0.image = .imgProfileDefault
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = Metric.profileSize / 2
            $0.layer.masksToBounds = true
            $0.clipsToBounds = true
        }

        profileClusterView.do {
            $0.isHidden = true
        }

        nameLabel.do {
            $0.setFont(.b2Sb16, textColor: .grey80)
        }

        genderLabel.do {
            $0.setFont(.b2M16, textColor: .primary40)
        }

        dotLabel.do {
            $0.setFont(.b2Sb16, text: "·", textColor: .grey80)
        }

        uploadedTimeLabel.do {
            $0.setFont(.b2M16, textColor: .grey50)
        }

        informationStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 4
        }

        placeLabel.do {
            $0.setFont(.b3M14, textColor: .grey80)
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }

        informationDotLabel.do {
            $0.setFont(.b3M14, text: "·", textColor: .grey80)
            $0.textAlignment = .center
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        meetingTimeLabel.do {
            $0.setFont(.b3M14, textColor: .grey80)
            $0.numberOfLines = 1
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        contentLabel.do {
            $0.setFont(.b3M14, textColor: .grey30)
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }

        nextButton.do {
            $0.setImage(.chevronRightIcon, for: .normal)
            $0.tintColor = .grey40
        }
    }

    private func setAddTarget() {
        nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }

    private func setUI() {
        profileContainerView.addSubviews(profileImageView, profileClusterView)
        informationStackView.addArrangedSubviews(placeLabel, informationDotLabel, meetingTimeLabel)
        contentView.addSubviews(
            profileContainerView, nameLabel,
            genderLabel, dotLabel, uploadedTimeLabel,
            informationStackView, contentLabel, nextButton
        )
    }

    private func setLayout() {
        profileContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Metric.verticalInset)
            $0.leading.equalToSuperview().inset(Metric.horizontalInset)
            $0.size.equalTo(Metric.profileSize)
        }

        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        updateProfileClusterSizeConstraint()

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileContainerView.snp.top)
            $0.leading.equalTo(profileContainerView.snp.trailing).offset(12)
            $0.height.equalTo(Metric.titleHeight)
        }

        genderLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel.snp.centerY)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(8)
            $0.height.equalTo(Metric.titleHeight)
        }

        dotLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel.snp.centerY)
            $0.leading.equalTo(genderLabel.snp.trailing).offset(4)
            $0.height.equalTo(Metric.titleHeight)
        }

        uploadedTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel.snp.centerY)
            $0.leading.equalTo(dotLabel.snp.trailing).offset(4)
            $0.height.equalTo(Metric.titleHeight)
        }

        informationStackView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(Metric.informationTopOffset)
            $0.leading.equalTo(nameLabel.snp.leading)
            informationTrailingToButtonConstraint = $0.trailing.lessThanOrEqualTo(nextButton.snp.leading).offset(-8).constraint
            informationTrailingToSuperviewConstraint = $0.trailing.lessThanOrEqualToSuperview().inset(Metric.horizontalInset).constraint
            $0.height.equalTo(Metric.informationHeight)
        }

        informationDotLabel.snp.makeConstraints {
            $0.width.equalTo(4)
        }

        informationTrailingToSuperviewConstraint?.deactivate()

        updateContentLabelTrailingConstraint(isNextButtonHidden: false)

        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Metric.horizontalInset)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }

    private func updateHeader(content: MatchingMatchedCardContentModel, displayMode: MatchingMatchedCardDisplayMode) {
        switch displayMode {
        case .list:
            nameLabel.setFont(.b2Sb16, text: content.name, textColor: .grey80)
            genderLabel.setFont(.b2M16, text: content.gender, textColor: .primary40)
            uploadedTimeLabel.setFont(.b2M16, text: content.uploadedTime, textColor: .grey50)
            genderLabel.isHidden = false
            dotLabel.isHidden = false
            uploadedTimeLabel.isHidden = false
        case .scheduleDetail:
            nameLabel.setFont(.b2Sb16, text: makeScheduleDetailTitle(content: content), textColor: .grey80)
            genderLabel.isHidden = true
            dotLabel.isHidden = true
            uploadedTimeLabel.isHidden = true
        }
    }

    private func makeScheduleDetailTitle(content: MatchingMatchedCardContentModel) -> String {
        let companionCount = max(content.participantCount - 1, 0)
        guard companionCount > 0 else {
            return "\(content.name)님과의 동행"
        }

        return "\(content.name)님 외 \(companionCount)명과의 동행"
    }

    private func updateProfileTopConstraint() {
        profileContainerView.snp.remakeConstraints {
            $0.top.equalToSuperview().inset(Metric.verticalInset)
            $0.leading.equalToSuperview().inset(Metric.horizontalInset)
            $0.width.equalTo(profileContainerWidth())
            $0.height.equalTo(profileContainerHeight())
        }
    }

    private func updateProfileClusterSizeConstraint() {
        profileClusterView.snp.remakeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(profileClusterView.contentSize)
        }
    }

    private func updateProfileImageCornerRadius() {
        let imageDiameter = min(profileImageView.bounds.width, profileImageView.bounds.height)
        let containerDiameter = min(profileContainerView.bounds.width, profileContainerView.bounds.height)
        let fallbackRadius = Metric.profileSize / 2

        profileImageView.layer.cornerRadius = imageDiameter > 0 ? imageDiameter / 2 : fallbackRadius
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true

        profileContainerView.layer.cornerRadius = containerDiameter > 0 ? containerDiameter / 2 : fallbackRadius
        profileContainerView.layer.masksToBounds = true
        profileContainerView.clipsToBounds = true
    }

    private func updateContentLabelTrailingConstraint(isNextButtonHidden: Bool) {
        contentLabel.snp.remakeConstraints {
            $0.top.equalTo(profileContainerView.snp.bottom).offset(Metric.contentTopOffset)
            $0.leading.equalTo(profileContainerView.snp.leading)

            if isNextButtonHidden {
                $0.trailing.equalToSuperview().inset(Metric.horizontalInset)
            } else {
                $0.trailing.equalTo(nextButton.snp.leading).offset(-8)
            }

            $0.height.equalTo(Metric.contentHeight)
            $0.bottom.equalToSuperview().inset(Metric.verticalInset)
        }
    }

    private func profileContainerWidth() -> CGFloat {
        if profileClusterView.isHidden {
            return Metric.profileSize
        }

        return max(profileClusterView.contentSize.width, Metric.profileSize)
    }

    private func profileContainerHeight() -> CGFloat {
        if profileClusterView.isHidden {
            return Metric.profileSize
        }

        return max(profileClusterView.contentSize.height, Metric.profileSize)
    }

    static func height(
        for content: MatchingMatchedCardContentModel,
        displayMode: MatchingMatchedCardDisplayMode = .list
    ) -> CGFloat {
        return height(participantCount: content.participantCount, displayMode: displayMode)
    }

    static func height(
        participantCount: Int = 1,
        displayMode: MatchingMatchedCardDisplayMode = .list
    ) -> CGFloat {
        let profileHeight: CGFloat
        switch displayMode {
        case .list:
            profileHeight = Metric.profileSize
        case .scheduleDetail:
            let avatarCount = min(max(participantCount, 1), 4)
            profileHeight = AvatarClusterView.contentSize(for: avatarCount).height
        }

        return Metric.verticalInset
            + profileHeight
            + Metric.contentTopOffset
            + Metric.contentHeight
            + Metric.verticalInset
    }

    private func updateProfile(content: MatchingMatchedCardContentModel, displayMode: MatchingMatchedCardDisplayMode) {
        switch displayMode {
        case .list:
            profileImageView.isHidden = false
            profileClusterView.isHidden = true
            updateProfileImage(content: content)
        case .scheduleDetail:
            profileImageView.isHidden = true
            profileClusterView.isHidden = false
            profileClusterView.configure(withImageURLs: makeProfileImageUrls(content: content))
            updateProfileClusterSizeConstraint()
        }
    }

    private func updateProfileImage(content: MatchingMatchedCardContentModel) {
        if let profileImageUrl = content.profileImageUrl,
           let url = URL(string: profileImageUrl) {
            profileImageView.kf.setImage(
                with: url,
                placeholder: content.profileImage ?? .imgProfileDefault,
                completionHandler: { [weak self] _ in
                    self?.updateProfileImageCornerRadius()
                }
            )
            updateProfileImageCornerRadius()
            return
        }

        profileImageView.image = content.profileImage ?? .imgProfileDefault
        updateProfileImageCornerRadius()
    }

    private func makeProfileImageUrls(content: MatchingMatchedCardContentModel) -> [String?] {
        let avatarCount = min(max(content.participantCount, 1), 4)
        let profileImageUrls = content.profileImageUrls.prefix(avatarCount)
        let emptyAvatarCount = max(avatarCount - profileImageUrls.count, 0)

        return Array(profileImageUrls) + [String?](repeating: nil, count: emptyAvatarCount)
    }

    func configure(
        content: MatchingMatchedCardContentModel,
        displayMode: MatchingMatchedCardDisplayMode = .list
    ) {
        contentView.backgroundColor = .bgSurfaceGrey0
        setNextButtonHidden(false)
        updateProfile(content: content, displayMode: displayMode)

        updateHeader(content: content, displayMode: displayMode)
        updateInformation(content: content)
        configureContentLabel(text: content.description, textColor: displayMode.descriptionColor)
        updateProfileTopConstraint()
    }

    func setNextButtonHidden(_ isHidden: Bool) {
        nextButton.isHidden = isHidden
        updateContentLabelTrailingConstraint(isNextButtonHidden: isHidden)

        if isHidden {
            informationTrailingToButtonConstraint?.deactivate()
            informationTrailingToSuperviewConstraint?.activate()
        } else {
            informationTrailingToSuperviewConstraint?.deactivate()
            informationTrailingToButtonConstraint?.activate()
        }
    }

    private func updateInformation(content: MatchingMatchedCardContentModel) {
        let hasPlace = !content.place.isEmpty
        let hasMeetingTime = !content.meetingTime.isEmpty

        configurePlaceLabel(text: content.place)
        meetingTimeLabel.setFont(.b3M14, text: content.meetingTime, textColor: .grey80)

        informationDotLabel.isHidden = !(hasPlace && hasMeetingTime)
        placeLabel.isHidden = !hasPlace
        meetingTimeLabel.isHidden = !hasMeetingTime
    }

    private func configurePlaceLabel(text: String) {
        let nearbyFont = NearbyFont.b3M14
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = nearbyFont.property.lineHeight
        paragraphStyle.maximumLineHeight = nearbyFont.property.lineHeight
        paragraphStyle.lineBreakMode = .byTruncatingTail

        let baselineOffset = (nearbyFont.property.lineHeight - nearbyFont.font.lineHeight) / 4

        placeLabel.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: nearbyFont.font,
                .paragraphStyle: paragraphStyle,
                .baselineOffset: baselineOffset,
                .foregroundColor: UIColor.grey80
            ]
        )
    }

    private func configureContentLabel(text: String, textColor: UIColor) {
        let nearbyFont = NearbyFont.b3M14
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = nearbyFont.property.lineHeight
        paragraphStyle.maximumLineHeight = nearbyFont.property.lineHeight
        paragraphStyle.lineBreakMode = .byTruncatingTail

        let baselineOffset = (nearbyFont.property.lineHeight - nearbyFont.font.lineHeight) / 4

        contentLabel.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: nearbyFont.font,
                .paragraphStyle: paragraphStyle,
                .baselineOffset: baselineOffset,
                .foregroundColor: textColor
            ]
        )
    }

    // MARK: - Action

    @objc
    private func nextButtonDidTap() {
        onNextButtonDidTap?()
    }
}
