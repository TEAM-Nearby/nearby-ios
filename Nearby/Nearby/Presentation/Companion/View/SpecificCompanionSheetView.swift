//
//  SpecificCompanionSheetView.swift
//  Nearby
//
//  Created by soomin on 7/9/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class SpecificCompanionSheetView: BaseView {

    // MARK: - Properties

    var titleMultilineDidChange: ((Bool) -> Void)?

    private var isTitleMultiline: Bool?
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    let closeButton = UIButton()
    private let placeImageView = UIImageView()
    private let placeNameLabel = UILabel()
    private let placeInfoLabel = UILabel()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    override func layoutSubviews() {
        super.layoutSubviews()

        guard titleLabel.bounds.width > 0 else { return }
        let fittingHeight = titleLabel.sizeThatFits(
            CGSize(width: titleLabel.bounds.width, height: .greatestFiniteMagnitude)
        ).height
        let isMultiline = fittingHeight > NearbyFont.h3Sb20.property.lineHeight + 0.5

        guard isTitleMultiline != isMultiline else { return }
        isTitleMultiline = isMultiline
        titleMultilineDidChange?(isMultiline)
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .white
        
        placeImageView.do {
            $0.backgroundColor = .grey5
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        titleLabel.do {
            $0.setFont(.h3Sb20, text: "내 주변에서 동행을 구하고 있어요", textColor: .grey80)
            $0.numberOfLines = 2
        }
        
        closeButton.do {
            $0.setImage(.cancelCircleIcon, for: .normal)
        }
        
        placeNameLabel.do {
            $0.setFont(.b2Sb16, textColor: .white)
        }
        
        placeInfoLabel.do {
            $0.setFont(.b3M14, textColor: .white)
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
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.lessThanOrEqualTo(closeButton.snp.leading).offset(-8)
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

    func configurePlace(with item: SpecificCompanionCellItem?) {
        placeImageView.kf.cancelDownloadTask()
        placeImageView.image = nil

        guard let item else {
            placeNameLabel.text = nil
            placeInfoLabel.text = nil
            return
        }

        placeNameLabel.setFont(.b2Sb16, text: item.placeName, textColor: .white)
        placeInfoLabel.setFont(.b3M14, text: item.placeInfo, textColor: .white)
        placeImageView.kf.setImage(
            with: item.placeImageURL,
            placeholder: nil
        )
    }

    func updateNickname(_ nickname: String) {
        titleLabel.setFont(
            .h3Sb20,
            text: "\(nickname)님 주변에서 동행을 구하고 있어요",
            textColor: .grey80
        )
        setNeedsLayout()
    }
    
    // MARK: - Method
    
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
