//
//  MatchedCardCollectionView.swift
//  Nearby
//
//  Created by 장지인 on 7/9/26.
//

import UIKit

import SnapKit
import Then

final class MatchedCardCollectionView: BaseView {

    // MARK: - UI Components

    private let navigationBar = NearbyNavigationBar()
    private let titleLabel = UILabel()
    private let emptyView = MatchingEmptyView()
    let matchedCardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    // MARK: - Property

    var findCompanionButton: UIButton {
        return emptyView.findCompanionButton
    }

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white
        navigationBar.do {
            $0.configure(centerItem: .logo, rightItems: [.alarm], logoLeadingInset: 20)
        }

        titleLabel.do {
            $0.setFont(.h1Sb24, text: "매칭된 동행 관리", textColor: .grey80)
        }

        matchedCardCollectionView.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.collectionViewLayout = Self.makeLayout()
        }

        emptyView.isHidden = true
    }

    override func setUI() {
        addSubviews(navigationBar, titleLabel, matchedCardCollectionView, emptyView)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(34)
        }

        matchedCardCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }

        emptyView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

    override func registerCells() {
        matchedCardCollectionView.register(MatchingMatchedCardCell.self)
    }

    // MARK: - Methods

    private static func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0

        return layout
    }

    func updateEmptyState(isEmpty: Bool) {
        titleLabel.isHidden = isEmpty
        matchedCardCollectionView.isHidden = isEmpty
        emptyView.isHidden = !isEmpty
    }
}
