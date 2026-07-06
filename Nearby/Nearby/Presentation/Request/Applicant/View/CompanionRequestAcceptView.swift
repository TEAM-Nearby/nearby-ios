//
//  CompanionRequestAcceptView.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import UIKit

import SnapKit
import Then

final class CompanionRequestAcceptView: BaseView {
    
    // MARK: - Property
    
    var onConfirmButtonDidTap: (() -> Void)?
    
    // MARK: - UI Components
    
    private let imageView = UIImageView()
    
    private let titleLabel = UILabel()
    
    private let informationView = UIStackView()
    
    private let locationStackView = UIStackView()
    private let locationImageView = UIImageView()
    private let locationLabel = UILabel()
    
    private let dateStackView = UIStackView()
    private let calendarImageView = UIImageView()
    private let dateLabel = UILabel()
    
    private let peopleStackView = UIStackView()
    private let peopleImageView = UIImageView()
    private let personImageView = UIImageView()
    private let avatarStackView = UIStackView()
    private let peopleLabel = UILabel()
    
    private let checkListView = UIStackView()
    private let checkListTitleLabel = UILabel()
    private let checkListDescriptionLabel = UILabel()
    
    private let confirmButton = NearbyButton(style: .primary, title: "")
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        imageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.setFont(.h2M22, text: "", textColor: .black)
            $0.textAlignment = .center
        }
        
        informationView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 16
            $0.axis = .vertical
            $0.spacing = 10
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        }
        
        locationStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
        
        locationImageView.do {
            $0.image = .smallLocationIcon
        }
        
        locationLabel.do {
            $0.setFont(.b2M16, text: "", textColor: .grey50)
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
            $0.setFont(.b2M16, text: "", textColor: .grey50)
            $0.textAlignment = .left
        }
        
        peopleStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
        
        personImageView.do {
            $0.image = .avatarStack
        }
        
        peopleImageView.do {
            $0.image = .peopleIcon
        }
        
        peopleLabel.do {
            $0.setFont(.b2M16, text: "", textColor: .grey50)
            $0.textAlignment = .left
        }
        
        avatarStackView.do {
            $0.axis = .horizontal
            $0.spacing = -12
            $0.alignment = .center
        }
        
        checkListView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 16
            $0.axis = .vertical
            $0.spacing = 17
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        }
        
        checkListTitleLabel.do {
            $0.setFont(.b2M16, text: "안전 체크리스트", textColor: .grey50)
            $0.textAlignment = .left
        }
        
        checkListDescriptionLabel.do {
            $0.setFont(.b3M14, text: "1. 숙소 정보는 공유하지 마세요.\n2. 오픈채팅을 제외한 개인 연락처를 강요하거나 반복적으로 요구하지 마세요.\n3. 사람이 많은 곳에서 처음 만나세요.\n4.금전 거래를 요구하는 경우 동행을 중단해주세요.\n5. 불쾌한 언행이나 위험을 느낄 시 즉시 대화와 동행을 종료하고 신고 기능을 이용해주세요.\n6.가족이나 친구에게 일정을 미리 공유하세요.", textColor: .grey40)
            $0.numberOfLines = 8
        }
    }
    
    override func setUI() {
        addSubviews(imageView, titleLabel, informationView, checkListView, confirmButton)
        informationView.addArrangedSubviews(locationStackView, dateStackView, peopleStackView)
        locationStackView.addArrangedSubviews(locationImageView, locationLabel)
        dateStackView.addArrangedSubviews(calendarImageView, dateLabel)
        (0..<3).forEach { _ in
                let avatar = UIImageView().then {
                    $0.image = .avatarStack
                    $0.contentMode = .scaleAspectFill
                    $0.layer.cornerRadius = 8
                    $0.clipsToBounds = true
                    $0.snp.makeConstraints { make in
                        make.size.equalTo(16)
                    }
                }
                avatarStackView.addArrangedSubview(avatar)
            }
        peopleStackView.addArrangedSubviews(peopleImageView, avatarStackView, peopleLabel)
        peopleStackView.setCustomSpacing(6, after: avatarStackView)
        checkListView.addArrangedSubviews(checkListTitleLabel, checkListDescriptionLabel)
    }
    
    override func setLayout() {
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(128)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
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
        
        personImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
        
        peopleImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        checkListView.snp.makeConstraints {
            $0.top.equalTo(informationView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
    }
    
    override func setAddTarget() {
        confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Method

    func configure(with output: CompanionRequestAcceptViewModel.DisplayData) {
        imageView.image = output.image
        titleLabel.text = output.title
        locationLabel.text = output.location
        dateLabel.text = output.date
        peopleLabel.text = output.people
        confirmButton.setTitle(output.buttonTitle, for: .normal)
    }
    
    // MARK: - Action
    
    @objc
    private func confirmButtonDidTap() {
        onConfirmButtonDidTap?()
    }
}
