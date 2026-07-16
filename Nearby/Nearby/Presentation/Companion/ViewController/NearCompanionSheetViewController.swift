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
    var onTitleMultilineChanged: ((Bool) -> Void)?

    private let initialLoadingTracker = InitialLoadingTracker()
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
        nearCompanionSheetView.titleMultilineDidChange = { [weak self] isMultiline in
            self?.onTitleMultilineChanged?(isMultiline)
        }
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
                guard let self else { return }
                initialLoadingTracker.complete(in: self)
                nearCompanionSheetView.collectionView.reloadData()
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
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let self {
                    initialLoadingTracker.complete(in: self)
                }
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
        initialLoadingTracker.begin(in: self)
        viewModel.action(.locationDidUpdate(coordinate))
    }

    func specificCompanions(for placeId: Int) -> [SpecificCompanionCellItem] {
        viewModel.specificCompanions(for: placeId)
    }

    func updatePlaceCategory(_ category: String) {
        viewModel.action(.placeCategoryDidSelect(category))
    }

    func updateNickname(_ nickname: String) {
        nearCompanionSheetView.updateNickname(nickname)
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
