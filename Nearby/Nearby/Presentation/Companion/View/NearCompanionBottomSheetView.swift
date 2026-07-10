//
//  NearCompanionBottomSheetView.swift
//  Nearby
//
//  Created by soomin on 7/9/26.
//

import UIKit

import SnapKit
import Then

final class NearCompanionBottomSheetView: BaseView {

    // MARK: - Properties

    private let sortOptions: [SortOption]
    private var sortButtons = [SortOption: NearbyChipButton]()
    
    var sortOptionDidTap: ((SortOption) -> Void)?
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let sortButtonStackView = UIStackView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - Initializer
    
    init(sortOptions: [SortOption]) {
        self.sortOptions = sortOptions
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .white
        
        titleLabel.do {
            $0.setFont(.h3Sb20, text: "지영님 주변에서 동행을 구하고 있어요", textColor: .grey80)
        }
        
        sortButtonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
        }
        
        collectionView.do {
            $0.collectionViewLayout = Self.makeLayout()
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = true
        }
    }
    
    override func setUI() {
        configureSortButtons()
        addSubviews(titleLabel, sortButtonStackView, collectionView)
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(NearbyFont.h3Sb20.property.lineHeight)
        }
        
        sortButtonStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(sortButtonStackView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    
    override func registerCells() {
        collectionView.register(NearCompanionCell.self)
    }
    
    // MARK: - Methods
    
    private func configureSortButtons() {
        sortOptions.forEach { option in
            let button = NearbyChipButton(style: .filterSortUnselected, title: option.title, horizontalInset: 16)
            
            button.addAction(UIAction { [weak self] _ in
                self?.sortOptionDidTap?(option)
            }, for: .touchUpInside)
            
            sortButtons[option] = button
            sortButtonStackView.addArrangedSubview(button)
        }
    }
    
    private static func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(172)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 66, trailing: 0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }

    func updateSortButtonSelection(_ selectedOption: SortOption) {
        sortButtons.forEach { option, button in
            button.updateSelected(option == selectedOption)
        }
    }

}
