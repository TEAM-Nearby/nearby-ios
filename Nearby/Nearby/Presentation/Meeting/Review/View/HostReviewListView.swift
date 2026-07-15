//
//  HostReviewListView.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import UIKit

import SnapKit
import Then

final class HostReviewListView: BaseView {
    
    // MARK: - Properties
    
    var onBackButtonDidTap: (() -> Void)?
    var onNotificationButtonDidTap: (() -> Void)?
    var onCompletionButtonDidTap: (() -> Void)?
    
    // MARK: - UI Components
    
    private let navigationBar = NearbyNavigationBar()
    
    private let contentView = UIStackView()
    
    private let companionInformationView = UIStackView()
    private let avatarClusterView = AvatarClusterView()
    private let labelStackView = UIStackView()
    private let peopleLabel = UILabel()
    private let informationLabel = UILabel()
    private let locationView = UIView()
    private let locationImage = UIImageView()
    private let locationLabel = UILabel()
    
    private let dividerView = UIView()
    
    private let reviewListStackView = UIStackView()
    
    private let completionButton = NearbyButton(style: .primary, title: "동행 마치기")
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        navigationBar.do {
            $0.configure(leftItem: .back, centerItem: .title("동행 후기"), rightItems: [.alarmButton])
        }
        
        contentView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 16
            $0.axis = .vertical
            $0.spacing = 24
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        }
        
        companionInformationView.do {
            $0.axis = .horizontal
            $0.spacing = 16
            $0.alignment = .center
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
        }
        
        peopleLabel.do {
            $0.setFont(.b2Sb16, text: "", textColor: .grey80)
        }
        
        informationLabel.do {
            $0.setFont(.b3M14, text: "", textColor: .grey50)
        }
        
        locationImage.do {
            $0.image = .smallLocationIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .primary50
        }
        
        locationLabel.do {
            $0.setFont(.c1Sb12, text: "", textColor: .primary50)
        }
        
        dividerView.do {
            $0.backgroundColor = .grey10
        }
        
        reviewListStackView.do {
            $0.axis = .vertical
            $0.spacing = 16
        }
    }
    
    override func setUI() {
        addSubviews(navigationBar, contentView, completionButton)
        contentView.addArrangedSubviews(companionInformationView, dividerView, reviewListStackView)
        companionInformationView.addArrangedSubviews(avatarClusterView, labelStackView)
        labelStackView.addArrangedSubviews(peopleLabel, informationLabel, locationView)
        labelStackView.setCustomSpacing(8, after: informationLabel)
        locationView.addSubviews(locationImage, locationLabel)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        dividerView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        locationView.snp.makeConstraints {
            $0.height.equalTo(17)
        }
        
        locationImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        locationLabel.snp.makeConstraints {
            $0.centerY.equalTo(locationImage.snp.centerY)
            $0.leading.equalTo(locationImage.snp.trailing).offset(6)
        }
        
        completionButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
    }
    
    override func setAddTarget() {
        navigationBar.leftButtonAction = { [weak self] in
            self?.onBackButtonDidTap?()
        }
        navigationBar.rightFirstButtonAction = { [weak self] in
            self?.onNotificationButtonDidTap?()
        }
        completionButton.addTarget(self, action: #selector(completionButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Action
    
    @objc
    private func completionButtonDidTap() {
        onCompletionButtonDidTap?()
    }
    
    // MARK: - Methods
    
    func configure(people: String, information: String, location: String, avatarImages: [UIImage?]) {
        avatarClusterView.configure(with: avatarImages)
        peopleLabel.text = people
        informationLabel.text = information
        locationLabel.text = location
    }
    
    func setReviewList(_ items: [ReviewItem], reviewedIDs: Set<Int>, onProfileTap: @escaping (ReviewItem) -> Void) {
        reviewListStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        items.forEach { item in
            let profileView = ReviewProfileView()
            profileView.configure(
                imageUrl: item.profileImageUrl,
                name: item.name,
                information: item.information,
                isReviewed: reviewedIDs.contains(item.id)
            )
            profileView.onNextButtonDidTap = { onProfileTap(item) }
            reviewListStackView.addArrangedSubview(profileView)
        }
    }
}
