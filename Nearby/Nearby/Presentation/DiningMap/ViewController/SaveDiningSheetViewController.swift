//
//  SaveDiningSheetViewController.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import Combine
import CoreLocation
import UIKit

final class SaveDiningSheetViewController: BaseViewController<SaveDiningSheetViewModel> {
    
    // MARK: - Properties
    
    var onEvent: ((DiningMapSheetEvent) -> Void)?
    
    private let initialLoadingTracker = InitialLoadingTracker()
    private let saveDiningBottomSheetView = SaveDiningBottomSheetView(diningCategories: DiningCategory.allCases)
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = saveDiningBottomSheetView
    }
    
    // MARK: - Custom Methods
    
    override func setDelegate() {
        saveDiningBottomSheetView.collectionView.dataSource = self
        saveDiningBottomSheetView.collectionView.delegate = self
    }
    
    override func bindAction() {
        saveDiningBottomSheetView.categoryDidTap = { [weak self] category in
            self?.viewModel.action(.categoryDidSelect(category))
        }
        saveDiningBottomSheetView.sortDidSelect = { [weak self] sort in
            self?.viewModel.action(.sortDidSelect(sort))
        }
    }
    
    override func bindState() {
        viewModel.output.selectedCategory
            .receive(on: DispatchQueue.main)
            .sink { [weak self] category in
                self?.saveDiningBottomSheetView.updateCategoryChipSelection(category)
            }
            .store(in: &cancellables)
        
        viewModel.output.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .idle, .loading:
                    break
                case .loaded(_, let totalCount, let markers):
                    initialLoadingTracker.complete(in: self)
                    saveDiningBottomSheetView.updateRestaurantCount(totalCount)
                    saveDiningBottomSheetView.collectionView.reloadData()
                    onEvent?(.markersChanged(markers))
                case .failed(let error):
                    initialLoadingTracker.complete(in: self)
                    AppLogger.error(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.selectedRestaurant
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.onEvent?(.restaurantSelected(item))
            }
            .store(in: &cancellables)
        
        viewModel.output.favoriteDidUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favorite in
                self?.onEvent?(.favoriteUpdated(placeId: favorite.placeId, isFavorite: favorite.isFavorite))
            }
            .store(in: &cancellables)
        
    }
    
    // MARK: - Methods
    
    func updateLocation(_ coordinate: CLLocationCoordinate2D) {
        initialLoadingTracker.begin(in: self)
        viewModel.action(.locationDidUpdate(coordinate))
    }
    
    func refresh() {
        viewModel.action(.refresh)
    }
    
    func restaurant(placeId: Int) -> NearDiningCellItem? {
        viewModel.restaurant(placeId: placeId)
    }
    
    func currentMapMarkers() -> [CompanionMapMarkerData] {
        viewModel.mapMarkers
    }
    
    func updateFavorite(placeId: Int, isFavorite: Bool) {
        viewModel.updateFavorite(placeId: placeId, isFavorite: isFavorite)
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
        cell.onImageTap = { [weak self] in
            self?.viewModel.action(.restaurantDidSelect(indexPath.item))
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
