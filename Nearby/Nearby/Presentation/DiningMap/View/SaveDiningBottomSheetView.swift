//
//  SaveDiningBottomSheetView.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import UIKit

import SnapKit
import Then

private final class DropdownOverflowScrollView: UIScrollView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
            || subviews.contains { subview in
                !subview.isHidden && subview.point(inside: convert(point, to: subview), with: event)
            }
    }
}

private final class DropdownOverflowStackView: UIStackView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
            || arrangedSubviews.contains { subview in
                !subview.isHidden && subview.point(inside: convert(point, to: subview), with: event)
            }
    }
}

final class SaveDiningBottomSheetView: BaseView {

    // MARK: - Properties

    private let diningCategories: [DiningCategory]
    private var categoryChips = [DiningCategory: NearbyIconChip]()
    var categoryDidTap: ((DiningCategory) -> Void)?
    var sortDidSelect: ((DiningFavoriteSortOption) -> Void)?

    // MARK: - UI Components

    private let titleLabel = UILabel()
    private let markerImageView = UIImageView()
    private let numberLabel = UILabel()
    private let categoryScrollView = DropdownOverflowScrollView()
    private let categoryChipStackView = DropdownOverflowStackView()
    private let sortDropdownView = NearbyDropdownView(
        items: DiningFavoriteSortOption.allCases.map(\.title),
        selectedItem: DiningFavoriteSortOption.latest.title
    )
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
            $0.setFont(.h3Sb20, text: "내가 저장한 맛집", textColor: .grey80)
        }
        
        markerImageView.do {
            $0.image = .smallLocationBlackIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .grey40
        }
        
        numberLabel.do {
            $0.setFont(.b3M14, textColor: .grey40)
        }

        categoryScrollView.do {
            $0.showsHorizontalScrollIndicator = false
            $0.alwaysBounceHorizontal = true
            $0.clipsToBounds = false
        }

        categoryChipStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 4
            $0.clipsToBounds = false
        }

        collectionView.do {
            $0.collectionViewLayout = Self.makeLayout()
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = true
        }

        sortDropdownView.onItemSelected = { [weak self] title in
            guard let sort = DiningFavoriteSortOption.allCases.first(where: { $0.title == title }) else { return }
            self?.sortDidSelect?(sort)
        }
    }

    override func setUI() {
        categoryScrollView.addSubview(categoryChipStackView)
        categoryChipStackView.addArrangedSubview(sortDropdownView)
        configureCategoryChips()
        addSubviews(titleLabel, markerImageView, numberLabel, collectionView, categoryScrollView)
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().inset(20)
        }
        
        markerImageView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.size.equalTo(16)
        }
        
        numberLabel.snp.makeConstraints {
            $0.leading.equalTo(markerImageView.snp.trailing).offset(6)
            $0.centerY.equalTo(markerImageView)
        }

        categoryScrollView.snp.makeConstraints {
            $0.top.equalTo(numberLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(sortDropdownView)
        }

        categoryChipStackView.snp.makeConstraints {
            $0.verticalEdges.equalTo(categoryScrollView.contentLayoutGuide)
            $0.leading.equalTo(categoryScrollView.contentLayoutGuide).offset(20)
            $0.trailing.equalTo(categoryScrollView.contentLayoutGuide).inset(20)
            $0.height.equalTo(categoryScrollView.frameLayoutGuide)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(categoryScrollView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    override func registerCells() {
        collectionView.register(SaveDiningCell.self)
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(188))
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

    func updateRestaurantCount(_ count: Int) {
        numberLabel.text = "\(count)개"
    }
}
