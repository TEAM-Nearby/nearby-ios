//
//  MeetingEmptyView.swift
//  Nearby
//
//  Created by h2e on 7/8/26.
//

import UIKit

import SnapKit
import Then

final class MeetingEmptyView: BaseView {
    
    // MARK: - Property
    
    var onSearchButtonDidTap: (() -> Void)?
    
    // MARK: - UI Components
    
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    let searchButton = NearbyButton(style: .primary, title: "내 주변의 동행 찾아보기")
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 40
        }
        
        imageView.do {
            $0.image = .illustLetterEmpty
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.setFont(.h1Sb24, text: "진행 중인 동행이 없어요!", textColor: .grey80)
            $0.textAlignment = .center
        }
        
        subTitleLabel.do {
            $0.setFont(.b2M16, text: "아래 버튼을 클릭해서\n함께 밥 먹을 동행을 구해보세요", textColor: .grey40)
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
        
        searchButton.do {
            $0.setTitle("내 주변의 동행 찾아보기", for: .normal)
        }
    }
    
    override func setUI() {
        addSubviews(stackView, searchButton)
        stackView.addArrangedSubviews(imageView, titleLabel, subTitleLabel)
        stackView.setCustomSpacing(16, after: titleLabel)
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview().multipliedBy(0.85)
            $0.horizontalEdges.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }
    }
    
    override func setAddTarget() {
        searchButton.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Action
    
    @objc
    private func searchButtonDidTap() {
        onSearchButtonDidTap?()
    }
}
