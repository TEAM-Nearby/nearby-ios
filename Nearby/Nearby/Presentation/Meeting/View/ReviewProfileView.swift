//
//  ReviewProfileView.swift
//  Nearby
//
//  Created by h2e on 7/6/26.
//

import UIKit

import SnapKit
import Then

final class ReviewProfileView: BaseView {
    
    // MARK: - Property
    
    var onNextButtonDidTap: (() -> Void)?
    
    // MARK: - UI Components
    
    private let profileStackView = UIStackView()
    private let imageView = UIImageView()
    
    private let labelStackView = UIStackView()
    private let nameLabel = UILabel()
    
    private let informationLabel = UILabel()
    
    private let nextButton = UIButton()

    // MARK: - Custom Methods
    
    override func setStyle() {
        profileStackView.do {
            $0.axis = .horizontal
            $0.spacing = 16
        }
        
        imageView.do {
            $0.image = .imgProfileDefault
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
        }
        
        nameLabel.do {
            $0.setFont(.b2Sb16, text: "정지영 님", textColor: .grey80)
            $0.textAlignment = .left
        }
        
        informationLabel.do {
            $0.setFont(.b3M14, text: "바르셀로나 · 2026년 6월 18일", textColor: .grey50)
            $0.textAlignment = .left
        }
        
        nextButton.do {
            $0.setImage(.chevronRightIcon, for: .normal)
        }
    }
    
    override func setUI() {
        addSubview(profileStackView)
        profileStackView.addArrangedSubviews(imageView, labelStackView, nextButton)
        profileStackView.setCustomSpacing(17, after: labelStackView)
        labelStackView.addArrangedSubviews(nameLabel, informationLabel)
    }
    
    override func setLayout() {
        profileStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(46)
        }
        
        nextButton.snp.makeConstraints {
            $0.size.equalTo(40)
        }
    }
    
    override func setAddTarget() {
        nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Action
    
    @objc
    private func nextButtonDidTap() {
        onNextButtonDidTap?()
        // TODO: - Coordinator 연결
    }
}
