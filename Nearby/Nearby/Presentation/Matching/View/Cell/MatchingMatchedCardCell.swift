//
//  MatchingMatchedCardCell.swift
//  Nearby
//
//  Created by 장지인 on 7/9/26.
//

import UIKit

import SnapKit
import Then

final class MatchingMatchedCardCell: UICollectionViewCell {

    // MARK: - Property

    var onNextButtonDidTap: (() -> Void)?

    // MARK: - UI Components

    private let confirmedLabel = UILabel()
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let genderLabel = UILabel()
    private let uploadedTimeLabel = UILabel()
    private let informationLabel = UILabel()
    private let contentLabel = UILabel()
    private let nextButton = UIButton()
    private let dotLabel = UILabel()

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

        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
    }

    // MARK: - Methods

    private func setStyle() {
        contentView.do {
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }

        confirmedLabel.do {
            $0.setFont(.b2Sb16, text: "일정 확정", textColor: .highlightTextPurple)
            $0.isHidden = true
        }

        profileImageView.do {
            $0.image = .imgProfileDefault
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
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

        informationLabel.do {
            $0.setFont(.b3M14, textColor: .grey80)
        }

        contentLabel.do {
            $0.setFont(.b3M14, textColor: .grey30)
            $0.numberOfLines = 1
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
        contentView.addSubviews(
            confirmedLabel, profileImageView, nameLabel,
            genderLabel, dotLabel, uploadedTimeLabel,
            informationLabel, contentLabel, nextButton
        )
    }

    private func setLayout() {
        confirmedLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(22)
        }

        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(19)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(40)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.height.equalTo(22)
        }

        genderLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel.snp.centerY)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(8)
            $0.height.equalTo(22)
        }

        dotLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel.snp.centerY)
            $0.leading.equalTo(genderLabel.snp.trailing).offset(4)
            $0.height.equalTo(22)
        }

        uploadedTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel.snp.centerY)
            $0.leading.equalTo(dotLabel.snp.trailing).offset(4)
            $0.height.equalTo(22)
        }

        informationLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.height.equalTo(20)
        }

        updateContentLabelTrailingConstraint(isNextButtonHidden: false)

        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }

    func configure(
        content: MatchingMatchedCardContentModel,
        state: MatchingMatchedCardState,
        displayMode: MatchingMatchedCardDisplayMode = .list
    ) {
        contentView.backgroundColor = state.backgroundColor
        setNextButtonHidden(false)
        confirmedLabel.isHidden = !state.showsConfirmedLabel
        profileImageView.image = content.profileImage ?? .imgProfileDefault

        updateHeader(content: content, displayMode: displayMode)
        informationLabel.setFont(.b3M14, text: "\(content.place) · \(content.meetingTime)", textColor: .grey80)
        contentLabel.setFont(.b3M14, text: content.description.truncated(limit: descriptionLimit(for: displayMode)), textColor: .grey30)
        updateProfileTopConstraint(state: state)
    }

    func setNextButtonHidden(_ isHidden: Bool) {
        nextButton.isHidden = isHidden
        updateContentLabelTrailingConstraint(isNextButtonHidden: isHidden)
    }

    // MARK: - Private Methods

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

        return "\(content.name)님 외 \(companionCount)명과의 동행"
    }

    private func descriptionLimit(for displayMode: MatchingMatchedCardDisplayMode) -> Int {
        switch displayMode {
        case .list:
            return 26
        case .scheduleDetail:
            return 30
        }
    }

    private func updateProfileTopConstraint(state: MatchingMatchedCardState) {
        profileImageView.snp.remakeConstraints {
            if state.showsConfirmedLabel {
                $0.top.equalTo(confirmedLabel.snp.bottom).offset(12)
            } else {
                $0.top.equalToSuperview().inset(19)
            }

            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(40)
        }
    }

    private func updateContentLabelTrailingConstraint(isNextButtonHidden: Bool) {
        contentLabel.snp.remakeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(12)
            $0.leading.equalTo(profileImageView.snp.leading)

            if isNextButtonHidden {
                $0.trailing.lessThanOrEqualToSuperview().inset(20)
            } else {
                $0.trailing.lessThanOrEqualTo(nextButton.snp.leading).offset(-8)
            }

            $0.height.equalTo(20)
        }
    }

    // MARK: - Actions

    @objc
    private func nextButtonDidTap() {
        onNextButtonDidTap?()
        // TODO: - 뷰 연결
    }
}
