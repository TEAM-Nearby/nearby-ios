//
//  NearDiningSheetViewController.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import Combine
import CoreLocation
import UIKit

final class NearDiningSheetViewController: BaseViewController<NearDiningBottomSheetViewModel> {
    
    // MARK: - Properties
    
    var onRestaurantSelected: ((NearDiningCellItem) -> Void)?
    var onMapMarkersChanged: (([CompanionMapMarkerData]) -> Void)?

    private let nearDiningBottomSheetView = NearDiningBottomSheetView(diningCategories: DiningCategory.allCases)

    // MARK: - Life Cycle

    override func loadView() {
        view = nearDiningBottomSheetView
    }
    
    // MARK: - Custom Methods

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

        viewModel.output.mapMarkers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] markers in
                self?.onMapMarkersChanged?(markers)
            }
            .store(in: &cancellables)

        viewModel.output.error
            .sink { error in
                AppLogger.error(error)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods

    func updateLocation(_ coordinate: CLLocationCoordinate2D) {
        viewModel.action(.locationDidUpdate(coordinate))
    }

    func restaurant(placeId: Int) -> NearDiningCellItem? {
        viewModel.restaurant(placeId: placeId)
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
        cell.onImageTap = { [weak self] in
            self?.viewModel.action(.restaurantDidSelect(indexPath.item))
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
