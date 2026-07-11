//
//  NearDiningSheetViewController.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import Combine
import UIKit

final class NearDiningSheetViewController: BaseViewController<NearDiningBottomSheetViewModel> {
    
    // MARK: - Properties
    
    var onRestaurantSelected: ((NearDiningCellItem) -> Void)?

    private let nearDiningBottomSheetView = NearDiningBottomSheetView(diningCategories: DiningCategory.allCases)

    // MARK: - Life Cycles

    override func loadView() {
        view = nearDiningBottomSheetView
    }

    override func setDelegate() {
        nearDiningBottomSheetView.collectionView.dataSource = self
        nearDiningBottomSheetView.collectionView.delegate = self
    }

    override func bindAction() {
        nearDiningBottomSheetView.categoryDidTap = { [weak self] category in
            self?.viewModel.action(.categoryDidSelect(category))
        }
    }

    override func bindState() {
        viewModel.output.selectedCategory
            .receive(on: DispatchQueue.main)
            .sink { [weak self] category in
                self?.nearDiningBottomSheetView.updateCategoryChipSelection(category)
            }
            .store(in: &cancellables)

        viewModel.output.restaurants
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.nearDiningBottomSheetView.collectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.output.selectedRestaurant
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.onRestaurantSelected?(item)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource

extension NearDiningSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.restaurantCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(NearDiningCell.self, for: indexPath)
        cell.configure(with: viewModel.restaurant(at: indexPath.item), isLast: indexPath.item == viewModel.restaurantCount - 1)
        cell.onBookmarkTap = { [weak self] in
            self?.viewModel.action(.bookmarkDidTap(indexPath.item))
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension NearDiningSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.action(.restaurantDidSelect(indexPath.item))
    }
}
