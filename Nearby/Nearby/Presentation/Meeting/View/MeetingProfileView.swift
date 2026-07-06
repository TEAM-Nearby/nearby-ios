//
//  MeetingProfileView.swift
//  Nearby
//
//  Created by h2e on 7/6/26.
//

import UIKit

import SnapKit
import Then

final class MeetingProfileView: BaseView {
    
    // MARK: - Properties
    
    var onVerifyButtonDidTap: (() -> Void)?
    
    // MARK: - UI Components
    
    private let contentStackView = UIStackView()
    
    private let profileStackView = UIStackView()
    private let imageView = UIImageView()
    private let hostStackView = UIStackView()
    
    private let hostIdentificationStackView = UIStackView()
    private let nameLabel = UILabel()
    private let identificationLabel = UILabel()
    
    private let informationStackView = UIStackView()
    private let locationLabel = UILabel()
    private let timeLabel = UILabel()

    // MARK: - Custom Methods
    
    override func setStyle() {
        profileStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
        
        imageView.do {
            $0.image = .imgProfileDefault
        }
        
        hostStackView.do {
            $0.axis = .vertical
            $0.spacing = 0
        }
        
        nameLabel.do {
            $0.text = "정지영"
            $0.textColor = .grey80
            $0.font = NearbyFont.b2Sb16.font
            $0.textAlignment = .left
        }
        
        identificationLabel.do {
            $0.text = "20대 여성"
            $0.textColor = .primary50
            $0.font = NearbyFont.b2M16.font
            $0.textAlignment = .left
        }
        
        hostIdentificationStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
        
        locationLabel.do {
            $0.text = "시우다드 콘달"
            $0.textColor = .grey80
            $0.font = NearbyFont.b3M14.font
            $0.textAlignment = .left
        }
        
        timeLabel.do {
            $0.text = "· 오후 4:30"
            $0.textColor = .grey80
            $0.font = NearbyFont.b3M14.font
            $0.textAlignment = .left
        }
        
        informationStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
        }
        
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
        }
    }
    
    override func setUI() {
        addSubview(profileStackView)
        profileStackView.addSubviews(imageView, hostStackView)
        hostStackView.addArrangedSubviews(hostIdentificationStackView, informationStackView)
        hostIdentificationStackView.addArrangedSubviews(nameLabel,identificationLabel)
        informationStackView.addArrangedSubviews(locationLabel, timeLabel)

    }
    
    override func setLayout() {
        profileStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.equalTo(46)
        }
        
        imageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.width.equalTo(46)
        }
        
        hostStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).offset(12)
        }
        
        hostIdentificationStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        informationStackView.snp.makeConstraints {
            $0.top.equalTo(hostIdentificationStackView.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
        }
    }
}
