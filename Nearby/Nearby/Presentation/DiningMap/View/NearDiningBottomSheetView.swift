//
//  NearDiningBottomSheetView.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import UIKit

import SnapKit
import Then

final class NearDiningBottomSheetView: BaseView {

    // MARK: - Properties

    private let diningCategories: [DiningCategory]
    private var categoryChips = [DiningCategory: NearbyIconChip]()

    var categoryDidTap: ((DiningCategory) -> Void)?

    // MARK: - UI Components

    private let titleLabel = UILabel()
    private let categoryScrollView = UIScrollView()
    private let categoryChipStackView = UIStackView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    // MARK: - Initializer

    init(diningCategories: [DiningCategory]) {
        self.diningCategories = diningCategories
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        titleLabel.do {
            $0.setFont(.h3Sb20, text: "바르셀로나에서\n혼자 가기 편한 식당을 알고 싶다면?", textColor: .grey80)
            $0.numberOfLines = 2
        }

        categoryScrollView.do {
            $0.showsHorizontalScrollIndicator = false
            $0.alwaysBounceHorizontal = true
        }

        categoryChipStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 4
        }

        collectionView.do {
            $0.collectionViewLayout = Self.makeLayout()
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = true
        }
    }

    override func setUI() {
        configureCategoryChips()
        categoryScrollView.addSubview(categoryChipStackView)
        addSubviews(titleLabel, categoryScrollView, collectionView)
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(NearbyFont.h3Sb20.property.lineHeight * 2)
        }

        categoryScrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(NearbyChipStyle.diningCategorySelected.height)
        }

        categoryChipStackView.snp.makeConstraints {
            $0.verticalEdges.equalTo(categoryScrollView.contentLayoutGuide)
            $0.horizontalEdges.equalTo(categoryScrollView.contentLayoutGuide).inset(20)
            $0.height.equalTo(categoryScrollView.frameLayoutGuide)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(categoryScrollView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
        }
    }

    override func registerCells() {
        collectionView.register(NearDiningCell.self)
    }

    // MARK: - Methods

    private func configureCategoryChips() {
        diningCategories.enumerated().forEach { index, category in
            let style: NearbyChipStyle = index == 0 ? .diningCategorySelected : .diningCategoryUnselected
            let chip = NearbyIconChip(style: style, title: category.title, icon: category.icon)

            chip.addAction(UIAction { [weak self] _ in
                self?.updateCategoryChipSelection(category)
                self?.categoryDidTap?(category)
            }, for: .touchUpInside)

            categoryChips[category] = chip
            categoryChipStackView.addArrangedSubview(chip)
        }
    }

    private static func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(245))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0)
        return UICollectionViewCompositionalLayout(section: section)
    }

    func updateCategoryChipSelection(_ selectedCategory: DiningCategory) {
        categoryChips.forEach { category, chip in
            chip.updateSelected(category == selectedCategory)
        }
    }
}
