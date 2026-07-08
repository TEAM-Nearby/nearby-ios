//
//  MeetingTabView.swift
//  Nearby
//
//  Created by h2e on 7/8/26.
//

import UIKit

import SnapKit
import Then

final class MeetingTabView: BaseView {

    // MARK: - UI Components

    private let navigationBar = NearbyNavigationBar()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white
        
        navigationBar.do {
            $0.configure(leftItem: .logo)
        }
        
        collectionView.do {
            $0.collectionViewLayout = Self.makeLayout()
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
        }
    }

    override func setUI() {
        addSubviews(navigationBar, collectionView)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: - Method

    private static func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(120)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: itemSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 20, bottom: 0, trailing: 20
        )

        return UICollectionViewCompositionalLayout(section: section)
    }
}
