//
//  NearCompanionSheetViewController.swift
//  Nearby
//
//  Created by soomin on 7/8/26.
//

import Combine
import CoreLocation
import UIKit

final class NearCompanionSheetViewController: BaseViewController<NearCompanionSheetViewModel> {

    // MARK: - Properties

    var onCompanionSelected: ((NearCompanionCellItem) -> Void)?
    var onSummaryTextChanged: ((String) -> Void)?
    var onMapMarkersChanged: (([CompanionMapMarkerData]) -> Void)?

    private var nearCompanionSheetView = NearCompanionBottomView(sortOptions: SortOption.allCases)

    // MARK: - Life Cycle

    override func loadView() {
        view = nearCompanionSheetView
    }

    // MARK: - Custom Methods

    override func setDelegate() {
        nearCompanionSheetView.collectionView.dataSource = self
        nearCompanionSheetView.collectionView.delegate = self
    }

    override func bindAction() {
        nearCompanionSheetView.sortOptionDidTap = { [weak self] option in
            self?.viewModel.action(.sortOptionDidTap(option))
        }
    }

    override func bindState() {
        viewModel.output.selectedSortOption
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedOption in
                self?.nearCompanionSheetView.updateSortButtonSelection(selectedOption)
            }
            .store(in: &cancellables)

        viewModel.output.companions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.nearCompanionSheetView.collectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.output.summaryText
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] summaryText in
                self?.onSummaryTextChanged?(summaryText)
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

        viewModel.output.selectedCompanion
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.onCompanionSelected?(item)
            }
            .store(in: &cancellables)
    }

    // MARK: - Method

    func updateLocation(_ coordinate: CLLocationCoordinate2D) {
        viewModel.action(.locationDidUpdate(coordinate))
    }

    func updatePlaceCategory(_ category: String) {
        viewModel.action(.placeCategoryDidSelect(category))
    }
}

// MARK: - UICollectionViewDataSource

extension NearCompanionSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.nearCompanionCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(NearCompanionCell.self, for: indexPath)
        cell.configure(with: viewModel.companion(at: indexPath.item))
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension NearCompanionSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.action(.companionDidSelect(indexPath.item))
    }
}
