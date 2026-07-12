//
//  CompanionDetailBottomView.swift
//  Nearby
//
//  Created by soomin on 7/10/26.
//

import UIKit

import SnapKit
import Then

final class CompanionDetailBottomView: BaseView {
    
    // MARK: - Property
    
    private let profileAvatarCount: Int = 3
    
    // MARK: - UI Components

    private let headerStackView = UIStackView()
    private let expirationBannerView = UIView()
    private let expirationLabel = UILabel()
    private let infoTitleLabel = UILabel()
    private let mapView = UIView()
    private let infoStackView = UIStackView()
    
    private let placeStackView = UIStackView()
    private let placeIconImageView = UIImageView()
    private let placeLabel = UILabel() 
    
    private let dateStackView = UIStackView()
    private let dateIconImageView = UIImageView()
    private let dateLabel = UILabel()
    
    private let peopleStackView = UIStackView()
    private let peopleIconImageView = UIImageView()
    private let peopleImageStackView = AvatarStackView()
    private let peopleStatusLabel = UILabel()
    
    private let containerView = UIView()
    private let contentLabel = UILabel()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .white

        headerStackView.do {
            $0.axis = .vertical
            $0.spacing = 16
            $0.alignment = .fill
        }

        expirationBannerView.do {
            $0.backgroundColor = .bgDefaultGrey
            $0.layer.cornerRadius = 12
            $0.isHidden = true
        }

        expirationLabel.do {
            $0.setFont(.b3M14, textColor: .grey60)
            $0.textAlignment = .center
        }
        
        infoTitleLabel.do {
            $0.setFont(.h3Sb20, text: "동행 정보", textColor: .grey80)
        }
        
        mapView.do {
            // TODO: - 지도 뷰 띄울 예정
            $0.backgroundColor = .grey40
        }
        
        infoStackView.do {
            $0.axis = .vertical
            $0.spacing = 11
        }
        
        placeStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.alignment = .center
        }
        
        placeIconImageView.do {
            $0.image = .smallLocationIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .grey80
        }
        
        placeLabel.do {
            $0.setFont(.b2M16, text: "장소명", textColor: .grey80)
            $0.transform = CGAffineTransform(translationX: 0, y: -1)
        }
        
        dateStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.alignment = .center
        }
        
        dateIconImageView.do {
            $0.image = .calenderIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .grey80
        }
        
        dateLabel.do {
            $0.setFont(.b2M16, text: "6월 18일 (목) 오후 4시 30분", textColor: .grey80)
            $0.transform = CGAffineTransform(translationX: 0, y: -1)
        }
        
        peopleStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.alignment = .center
        }

        peopleIconImageView.do {
            $0.image = .peopleIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .grey80
        }

        peopleImageStackView.do {
            $0.configureWithDefaultAvatars(count: profileAvatarCount)
        }
        
        peopleStatusLabel.do {
            $0.setFont(.b2M16, text: "3/4명", textColor: .grey80)
            $0.transform = CGAffineTransform(translationX: 0, y: -1)
        }
        
        containerView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }
        
        contentLabel.do {
            $0.setFont(.b3M14, text: "같이 스시 먹으러 갈 사람~~여기 제가 정말 좋아하는 스시집인데 혼자 먹기는 양이 너무 많아서 동행 구해봐요 같은 동성이면 더 좋을 것 같아요 밥 먹고 카페까지 같이 가면 좋을 것 같습니다 저는 친구 한 명과 같이 왔어요!", textColor: .grey60)
            $0.numberOfLines = 0
        }
    }
    
    override func setUI() {
        expirationBannerView.addSubview(expirationLabel)
        headerStackView.addArrangedSubviews(expirationBannerView, infoTitleLabel)
        placeStackView.addArrangedSubviews(placeIconImageView, placeLabel)
        dateStackView.addArrangedSubviews(dateIconImageView, dateLabel)
        peopleStackView.addArrangedSubviews(peopleIconImageView, peopleImageStackView, peopleStatusLabel)
        infoStackView.addArrangedSubviews(placeStackView, dateStackView, peopleStackView)
        containerView.addSubview(contentLabel)
        addSubviews(headerStackView, mapView, infoStackView, containerView)
    }
    
    override func setLayout() {
        headerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        expirationBannerView.snp.makeConstraints {
            $0.height.equalTo(42)
        }

        expirationLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(infoTitleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(143)
        }
        
        placeIconImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        peopleIconImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }

        dateIconImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(13)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(infoStackView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        contentLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }

    // MARK: - Method

    func configure(postType: PostType) {
        switch postType {
        case .scheduled:
            expirationBannerView.isHidden = true
            expirationLabel.text = nil
        case .immediate:
            // TODO: - 서버 immediate 값 질문
//            expirationLabel.setFont(.b3M14, text: "이 글은 \(expirationTime)에 사라져요!", textColor: .grey60)
            expirationBannerView.isHidden = false
        }
    }
}
