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
    
    private let profileView = UIView()
    private let imageView = UIImageView()
    private let hostStackView = UIStackView()
    
    private let hostIdentificationStackView = UIStackView()
    private let nameLabel = UILabel()
    private let identificationLabel = UILabel()
    
    private let informationLabel = UILabel()

    private let nextButton = UIButton()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        imageView.do {
            $0.image = .imgProfileDefault
        }
        
        nameLabel.do {
            $0.setFont(.b2Sb16, text: "정지영", textColor: .grey80)
            $0.textAlignment = .left
        }
        
        identificationLabel.do {
            $0.setFont(.b2M16, text: "20대 여성", textColor: .primary50)
            $0.textAlignment = .left
        }
        
        hostIdentificationStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
        
        informationLabel.do {
            $0.setFont(.b3M14, text: "시우다드 콘달 · 오후 4:30", textColor: .grey80)
            $0.textAlignment = .left
        }
        
        nextButton.do {
            $0.setImage(.chevronRightIcon, for: .normal)
        }
    }
    
    override func setUI() {
        addSubview(profileView)
        profileView.addSubviews(imageView, hostStackView, nextButton)
        hostStackView.addSubviews(hostIdentificationStackView, informationLabel)
        hostIdentificationStackView.addSubviews(nameLabel, identificationLabel)
    }
    
    override func setLayout() {
        profileView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.height.width.equalTo(46)
        }
        
        nextButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview()
        }
        
        hostIdentificationStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).offset(12)
            $0.height.equalTo(22)
        }
        
        informationLabel.snp.makeConstraints {
            $0.top.equalTo(hostIdentificationStackView.snp.bottom).offset(4)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        identificationLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.top)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(12)
        }
    }
}
