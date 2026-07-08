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
    private let hostView = UIView()
    
    private let hostIdentificationView = UIView()
    private let nameLabel = UILabel()
    private let genderLabel = UILabel()
    
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
        
        genderLabel.do {
            $0.setFont(.b2M16, text: "20대 여성", textColor: .primary50)
            $0.textAlignment = .left
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
        profileView.addSubviews(imageView, hostView, nextButton)
        hostView.addSubviews(hostIdentificationView, informationLabel)
        hostIdentificationView.addSubviews(nameLabel, genderLabel)
    }
    
    override func setLayout() {
        profileView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(46)
            $0.verticalEdges.leading.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(imageView.snp.centerY)
        }
        
        hostView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualTo(nextButton.snp.leading).offset(-8)
        }
        
        hostIdentificationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).offset(12)
            $0.height.equalTo(22)
        }
        
        informationLabel.snp.makeConstraints {
            $0.top.equalTo(hostIdentificationView.snp.bottom).offset(4)
            $0.bottom.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        genderLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.top)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(8)
        }
    }
    
    // MARK: - Method
    
    func configure(name: String, gender: String, information: String) {
        nameLabel.text = name
        genderLabel.text = gender
        informationLabel.text = information
    }
}
