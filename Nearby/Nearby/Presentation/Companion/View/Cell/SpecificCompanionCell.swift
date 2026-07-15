//
//  SpecificCompanionCell.swift
//  Nearby
//
//  Created by soomin on 7/9/26.
//

import UIKit

import SnapKit
import Then

final class SpecificCompanionCell: UICollectionViewCell {
    
    // MARK: - Property
    
    private let profileAvatarCount = 4
    
    // MARK: - UI Components
    
    private let profileImageView = GradientCircleView(diameter: 44)
    
    private let hostStackView = UIStackView()
    private let hostNameLabel = UILabel()
    private let hostGenderChip = NearbyChipButton(style: .badgeProfile, title: "여성", horizontalInset: 6)
    
    private let writtenTimeLabel = UILabel()
    private let contentLabel = UILabel()
    
    private let timeStackView = UIStackView()
    private let meetingTimeLabel = UILabel()
    private let closedTimeLabel = UILabel()
    
    private let applyInfoStackView = UIStackView()
    private let profileStackView = AvatarStackView()
    private let overflowCountLabel = UILabel()
    private let currentStatusLabel = UILabel()
    
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
    
    // MARK: - Methods
    
    private func setStyle() {
        contentView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.grey10.cgColor
            $0.clipsToBounds = true
        }
        
        hostStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
            $0.alignment = .leading
        }
        
        hostNameLabel.do {
            $0.setFont(.b1M18, text: "", textColor: .black)
        }
        
        writtenTimeLabel.do {
            $0.setFont(.c1M12, text: "", textColor: .grey30)
        }
        
        contentLabel.do {
            $0.setFont(.b3M14, text: "", textColor: .grey60)
            $0.numberOfLines = 2
        }
        
        meetingTimeLabel.do {
            $0.setFont(.b2M16, text: "", textColor: .grey80)
        }
        
        closedTimeLabel.do {
            $0.setFont(.b3M14, text: "", textColor: .grey40)
        }
        
        timeStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
        }
        
        applyInfoStackView.do {
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
        
        currentStatusLabel.do {
            $0.setFont(.b3M14, text: "3/4 모집 중", textColor: .btnPrimaryBg)
        }
        
        profileStackView.do {
            $0.configureWithDefaultAvatars(count: profileAvatarCount)
        }
    }
    
    private func setUI() {
        hostStackView.addArrangedSubviews(hostNameLabel, hostGenderChip)
        timeStackView.addArrangedSubviews(meetingTimeLabel, closedTimeLabel)
        applyInfoStackView.addArrangedSubviews(
            profileStackView,
            overflowCountLabel,
            currentStatusLabel
        )
        contentView.addSubviews(profileImageView, hostStackView, writtenTimeLabel, contentLabel, timeStackView, applyInfoStackView)
    }
    
    private func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(19)
        }
        
        hostStackView.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        writtenTimeLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(hostStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        timeStackView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(7)
            $0.leading.equalTo(contentLabel)
            $0.bottom.equalToSuperview().inset(17)
        }
        
        applyInfoStackView.snp.makeConstraints {
            $0.leading.equalTo(timeStackView.snp.trailing).offset(37)
            $0.centerY.equalTo(timeStackView)
        }
    }
    
    func configure(with item: SpecificCompanionCellItem) {
        profileImageView.configure(imageUrl: item.profileImageURL)
        hostNameLabel.text = item.hostName
        hostGenderChip.updateTitle(item.genderTitle)
        writtenTimeLabel.text = item.writtenTime
        contentLabel.text = item.content
        meetingTimeLabel.text = item.meetingTime
        closedTimeLabel.text = item.closedTime
        profileStackView.configure(
            withImageURLs: Array(
                item.participantImageURLs.prefix(profileAvatarCount)
            )
        )
        configureOverflowCount(item.detailState.participantCount)
        currentStatusLabel.text = item.statusText
    }

    private func configureOverflowCount(_ participantCount: Int) {
        let overflowCount = max(participantCount - profileAvatarCount, 0)
        overflowCountLabel.text = overflowCount > 0 ? "+\(overflowCount)" : nil
        overflowCountLabel.isHidden = overflowCount == 0

        applyInfoStackView.setCustomSpacing(
            overflowCount > 0 ? 0 : 6,
            after: profileStackView
        )
        applyInfoStackView.setCustomSpacing(6, after: overflowCountLabel)
    }
}
