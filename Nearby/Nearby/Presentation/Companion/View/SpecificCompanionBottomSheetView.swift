//
//  SpecificCompanionBottomSheetView.swift
//  Nearby
//
//  Created by soomin on 7/9/26.
//

import UIKit

import SnapKit
import Then

final class SpecificCompanionBottomSheetView: BaseView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let placeImageView = UIImageView()
    private let placeNameLabel = UILabel()
    private let placeInfoLabel = UILabel()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .white
        
        // TODO: 서버 연동 후 placeholder 제거
        
        placeImageView.do {
            $0.image = .restaurantPlaceholder
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        titleLabel.do {
            $0.setFont(.h3Sb20, text: "지영님 주변에서 동행을 구하고 있어요", textColor: .grey80)
        }
        
        closeButton.do {
            $0.setImage(.cancelCircleIcon, for: .normal)
        }
        
        // TODO: 서버 연동 후 mock 제거
        
        placeNameLabel.do {
            $0.setFont(.b2Sb16, text: "킷사덴 오노데라", textColor: .white)
        }
        
        placeInfoLabel.do {
            $0.setFont(.b3M14, text: "스시 · 1km", textColor: .white)
        }
        
        collectionView.do {
            $0.collectionViewLayout = Self.makeLayout()
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = true
        }
    }
    
    override func setUI() {
        addSubviews(titleLabel, placeImageView, placeNameLabel, placeInfoLabel, closeButton, collectionView)
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(NearbyFont.h3Sb20.property.lineHeight)
        }
        
        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(14)
        }
        
        placeImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.height.equalTo(150)
        }
        
        placeInfoLabel.snp.makeConstraints {
            $0.bottom.equalTo(placeImageView.snp.bottom).offset(-8)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(NearbyFont.b3M14.property.lineHeight)
        }
        
        placeNameLabel.snp.makeConstraints {
            $0.leading.equalTo(placeInfoLabel)
            $0.bottom.equalTo(placeInfoLabel.snp.top).offset(-2)
            $0.height.equalTo(NearbyFont.b2Sb16.property.lineHeight)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(placeImageView.snp.bottom).offset(16).priority(.high)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func registerCells() {
        collectionView.register(SpecificCompanionCell.self)
    }
    
    private static func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(168)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 24, trailing: 16)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
