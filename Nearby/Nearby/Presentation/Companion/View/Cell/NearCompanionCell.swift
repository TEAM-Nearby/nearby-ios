//
//  NearCompanionCell.swift
//  Nearby
//
//  Created by soomin on 7/8/26.
//

import UIKit

import SnapKit
import Then

final class NearCompanionCell: UICollectionViewCell {
    
    // MARK: - Property
    
    private let profileAvatarCount: Int = 2
    
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
    private let currentStatusLabel = UILabel()
    private let arrowIcon = UIImageView()
    
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
        dividerView.do {
            $0.backgroundColor = .grey5
        }
        
        placeImageView.do {
            $0.image = .restaurantPlaceholder
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 16
        }
        
        placeNameLabel.do {
            $0.setFont(.b2M16, text: "손오공 마라탕", textColor: .grey80)
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        
        timeLabel.do {
            $0.setFont(.c1R12, text: "30분 전", textColor: .grey30)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        
        contentLabel.do {
            $0.setFont(.c1M12, text: "같이 스시 먹으러 갈 사람~~여기 제가 정말 좋아하는 스시집인데 가격은 조금 비싸지만...", textColor: .grey70)
            $0.numberOfLines = 2
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
            $0.spacing = 7
            $0.alignment = .center
        }
        
        profileStackView.configureWithDefaultAvatars(count: profileAvatarCount)
        
        scheduleLabel.do {
            $0.setFont(.c1R12, text: "6월 29일 14:00", textColor: .grey70)
        }
        
        currentStatusLabel.do {
            $0.setFont(.c1M12, text: "2/4 모집 중", textColor: .highlightTextPurple)
        }
        
        arrowIcon.do {
            $0.image = .chevronRightIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .grey40
        }
    }
    
    private func setUI() {
        contentView.addSubviews(dividerView, placeImageView, placeNameLabel, timeLabel, contentLabel, timeStackView, peopleStackView, arrowIcon)
        timeStackView.addArrangedSubviews(clockIcon, scheduleLabel)
        peopleStackView.addArrangedSubviews(profileStackView, currentStatusLabel)
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
        }
        
        placeNameLabel.snp.makeConstraints {
            $0.top.equalTo(placeImageView).offset(9)
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
            $0.bottom.equalToSuperview().inset(25)
            $0.leading.equalTo(contentLabel.snp.leading).offset(3)
        }
        
        profileStackView.snp.makeConstraints {
            $0.height.equalTo(profileStackView.contentSize.height)
        }
        
        arrowIcon.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(profileStackView)
        }
    }
    
    func configure(with item: NearCompanionCellItem) {
        placeImageView.image = item.placeImage ?? .restaurantPlaceholder
        placeNameLabel.text = item.placeName
        timeLabel.text = item.writtenTime
        contentLabel.text = item.content
        scheduleLabel.text = item.schedule
        profileStackView.configure(with: item.participantImages)
        currentStatusLabel.text = item.statusText
    }
}
