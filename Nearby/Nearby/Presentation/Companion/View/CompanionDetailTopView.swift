//
//  CompanionDetailTopView.swift
//  Nearby
//
//  Created by soomin on 7/10/26.
//

import UIKit

import SnapKit
import Then

final class CompanionDetailTopView: BaseView {
    
    // MARK: - Properties
    
    private var tagCollectionHeight: CGFloat = 36
    
    // MARK: - UI Components
    
    private let hostProfileImageView = GradientCircleView(diameter: 65)
    private let hostMainInfoStackView = UIStackView()
    private let hostNameLabel = UILabel()
    private let genderLabel = UILabel()
    
    private let hostSubInfoLabel = UILabel()
    private let mannerScoreLabel = UILabel()
    private let arrowImageView = UIImageView()
    
    private let containerView = UIView()
    private let introduceLabel = UILabel()
    
    lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()

        tagCollectionView.collectionViewLayout.invalidateLayout()
        tagCollectionView.layoutIfNeeded()
        let contentHeight = tagCollectionView.collectionViewLayout.collectionViewContentSize.height
        guard contentHeight > 0, abs(tagCollectionHeight - contentHeight) > 0.5 else { return }

        tagCollectionHeight = contentHeight
        tagCollectionView.snp.updateConstraints {
            $0.height.equalTo(contentHeight)
        }
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        self.backgroundColor = .bgDefaultGrey
        
        hostMainInfoStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
        }
        
        hostNameLabel.do {
            $0.setFont(.h3Sb20, text: "조예원")
        }
        
        genderLabel.do {
            $0.setFont(.b2M16, text: "여성", textColor: .primary50)
        }
        
        hostSubInfoLabel.do {
            $0.setFont(.b3M14, text: "본인 인증 완료 · 매너 지수", textColor: .grey60)
        }
        
        mannerScoreLabel.do {
            $0.setFont(.b1Sb18, text: "4", textColor: .primary50)
        }
        
        arrowImageView.do {
            $0.image = .chevronRightIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .grey50
        }
        
        containerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }
        
        introduceLabel.do {
            $0.setFont(.b2M16, text: "안녕하세요~ 조예원이라고 합니다! 같이 맛있는 것도 먹고 구경도 해요~~언제든 환영입니다!", textColor: .grey70)
            $0.numberOfLines = 0
        }
        
        tagCollectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
        }
    }
    
    override func setUI() {
        hostMainInfoStackView.addArrangedSubviews(hostNameLabel, genderLabel)
        containerView.addSubviews(introduceLabel, tagCollectionView)
        addSubviews(hostProfileImageView, hostMainInfoStackView, hostSubInfoLabel,
                    mannerScoreLabel, arrowImageView, containerView)
    }
    
    override func setLayout() {
        hostProfileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(65)
        }
        
        hostMainInfoStackView.snp.makeConstraints {
            $0.top.equalTo(hostProfileImageView.snp.top).offset(4)
            $0.leading.equalTo(hostProfileImageView.snp.trailing).offset(16)
        }
        
        hostSubInfoLabel.snp.makeConstraints {
            $0.top.equalTo(hostMainInfoStackView.snp.bottom).offset(7)
            $0.leading.equalTo(hostMainInfoStackView.snp.leading)
        }
        
        mannerScoreLabel.snp.makeConstraints {
            $0.centerY.equalTo(hostSubInfoLabel)
            $0.leading.equalTo(hostSubInfoLabel.snp.trailing).offset(6)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(hostSubInfoLabel)
            $0.leading.equalTo(mannerScoreLabel.snp.trailing).offset(4)
            $0.size.equalTo(24)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(hostProfileImageView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        introduceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(introduceLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(36)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func registerCells() {
        tagCollectionView.register(NearbyTextChipCollectionViewCell.self)
    }
    
    // MARK: - Methods
    
    private func makeLayout() -> UICollectionViewFlowLayout {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        return layout
    }
}
