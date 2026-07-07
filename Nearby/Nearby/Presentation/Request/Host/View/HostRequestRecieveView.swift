//
//  HostRequestRecieveView.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import UIKit

import SnapKit
import Then

final class HostRequestAcceptView: BaseView {
    
    // MARK: - Properties
    
    var onAllowButtonDidTap: (() -> Void)?
    var onRejectButtonDidTap: (() -> Void)?
    var onBackButtonDidTap: (() -> Void)?
    
    // MARK: - UI Components
    
    private let titleView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    private let applicantView = UIStackView()
    
    private let profileView = UIStackView()
    private let profileImageView = UIImageView()
    
    private let labelStackView = UIStackView()
    
    private let profileInformationStackView = UIStackView()
    private let nameLabel = UILabel()
    private let genderLabel = UILabel()
    
    private let identificationStackView = UIStackView()
    private let identificationLabel = UILabel()
    private let levelLabel = UILabel()
    private let nextButton = UIButton()
    
    private let dividerView = UIView()
    
    private let informationView = UIStackView()
    
    private let locationStackView = UIStackView()
    private let locationImageView = UIImageView()
    private let locationLabel = UILabel()
    
    private let dateStackView = UIStackView()
    private let calendarImageView = UIImageView()
    private let dateLabel = UILabel()
    
    private let allowButton = NearbyButton(style: .allowed, title: "수락하기")
    private let rejectButton = NearbyButton(style: .rejected, title: "거절하기")
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        imageView.do {
            $0.contentMode = .scaleAspectFill
        }
        
        titleLabel.do {
            $0.setFont(.h2M22, text: "", textColor: .black)
            $0.textAlignment = .center
        }
        
        subTitleLabel.do {
            $0.setFont(.b2M16, text: "", textColor: .grey30)
        }
        
        applicantView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 16
            $0.axis = .vertical
            $0.spacing = 16
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        }
        
        dividerView.do {
            $0.backgroundColor = .grey10
        }
        
        locationStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
        
        locationImageView.do {
            $0.image = .smallLocationIcon
        }
        
        locationLabel.do {
            $0.setFont(.b2M16, text: "", textColor: .grey80)
            $0.textAlignment = .left
        }
        
        dateStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
        
        calendarImageView.do {
            $0.image = .calenderIcon
        }
        
        dateLabel.do {
            $0.setFont(.b2M16, text: "", textColor: .grey80)
            $0.textAlignment = .left
        }
    }
    
    override func setUI() {
        addSubviews(titleView, applicantView)
        titleView.addSubviews(imageView, titleLabel, subTitleLabel)
        applicantView.addArrangedSubviews(profileView, dividerView,informationView)
        profileView.addArrangedSubviews(profileImageView, labelStackView)
        labelStackView.addArrangedSubviews(profileInformationStackView,identificationStackView)
        profileInformationStackView.addArrangedSubviews(nameLabel, genderLabel)
        identificationStackView.addArrangedSubviews(identificationLabel, nextButton)
        informationView.addArrangedSubviews(locationStackView, dateStackView)
        locationStackView.addArrangedSubviews(locationImageView, locationLabel)
        dateStackView.addArrangedSubviews(calendarImageView, dateLabel)
    }
    
    override func setLayout() {
        imageView.snp.makeConstraints {
            $0.top.equalTo(self.snp.centerY).offset(-93)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(129)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        applicantView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(65)
        }
        
        
        
        informationView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(34)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        locationImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        calendarImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
    }
    
    override func setAddTarget() {
        rejectButton.addTarget(self, action: #selector(rejectButtonDidTap), for: .touchUpInside)
        allowButton.addTarget(self, action: #selector(allowButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Method
    
    func configure(with output: CompanionRequestAcceptViewModel.DisplayData) {
        imageView.image = output.image
        titleLabel.text = output.title
        locationLabel.text = output.location
        dateLabel.text = output.date
    }
    
    // MARK: - Actions
    
    @objc
    private func allowButtonDidTap() {
        onAllowButtonDidTap?()
    }
    
    @objc
    private func rejectButtonDidTap() {
        onRejectButtonDidTap?()
    }
}
