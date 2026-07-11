//
//  SaveDiningSheetViewController.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import Combine
import UIKit

final class SaveDiningSheetViewController: BaseViewController<SaveDiningSheetViewModel> {
    
    // MARK: - Properties
    
    var onRestaurantSelected: ((NearDiningCellItem) -> Void)?

    private let saveDiningBottomSheetView = SaveDiningBottomSheetView(diningCategories: DiningCategory.allCases)

    // MARK: - Life Cycles

    override func loadView() {
        view = saveDiningBottomSheetView
    }

    override func setDelegate() {
        saveDiningBottomSheetView.collectionView.dataSource = self
        saveDiningBottomSheetView.collectionView.delegate = self
    }

    override func bindAction() {
        saveDiningBottomSheetView.categoryDidTap = { [weak self] category in
            self?.viewModel.action(.categoryDidSelect(category))
        }
    }

    override func bindState() {
        viewModel.output.selectedCategory
            .receive(on: DispatchQueue.main)
            .sink { [weak self] category in
                self?.saveDiningBottomSheetView.updateCategoryChipSelection(category)
            }
            .store(in: &cancellables)

        viewModel.output.restaurants
            .receive(on: DispatchQueue.main)
            .sink { [weak self] restaurants in
                self?.saveDiningBottomSheetView.updateRestaurantCount(restaurants.count)
                self?.saveDiningBottomSheetView.collectionView.reloadData()
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

extension SaveDiningSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.restaurantCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(SaveDiningCell.self, for: indexPath)
        cell.configure(with: viewModel.restaurant(at: indexPath.item), isLast: indexPath.item == viewModel.restaurantCount - 1)
        cell.onBookmarkTap = { [weak self] in
            self?.viewModel.action(.bookmarkDidTap(indexPath.item))
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SaveDiningSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.action(.restaurantDidSelect(indexPath.item))
    }
}
