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
    
    // MARK: - UI Components
    
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
    }
    
    override func setUI() {
        addSubview(profileStackView)
        profileStackView.addArrangedSubviews(imageView, hostStackView)
        hostStackView.addSubviews(hostIdentificationStackView, informationStackView)
        hostIdentificationStackView.addSubviews(nameLabel, identificationLabel)
        informationStackView.addSubviews(locationLabel, timeLabel)
    }
    
    override func setLayout() {
        profileStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.height.width.equalTo(46)
        }
        
        hostIdentificationStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(22)
        }
        
        informationStackView.snp.makeConstraints {
            $0.top.equalTo(hostIdentificationStackView.snp.bottom).offset(4)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        identificationLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.top)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(12)
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.top)
            $0.leading.equalTo(locationLabel.snp.trailing)
        }
    }
}
