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
    var onCompanionAvailabilityChanged: ((Bool) -> Void)?

    private var nearCompanionSheetView = NearCompanionBottomView(sortOptions: SortOption.allCases)
    private var isShowingSkeleton = false

    var listState: AnyPublisher<NearCompanionSheetViewModel.ViewState, Never> {
        viewModel.output.viewState.eraseToAnyPublisher()
    }

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

        viewModel.output.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }

                switch state {
                case .idle:
                    isShowingSkeleton = false
                    nearCompanionSheetView.collectionView.reloadData()
                case .loading:
                    isShowingSkeleton = true
                    nearCompanionSheetView.collectionView.reloadData()
                case .loaded(let items, let markers, let summaryText):
                    isShowingSkeleton = false
                    nearCompanionSheetView.collectionView.reloadData()
                    onCompanionAvailabilityChanged?(!items.isEmpty)
                    onSummaryTextChanged?(summaryText)
                    onMapMarkersChanged?(markers)
                case .failed(let error):
                    isShowingSkeleton = false
                    nearCompanionSheetView.collectionView.reloadData()
                    AppLogger.error(error)
                }
            }
            .store(in: &cancellables)

        viewModel.output.selectedCompanion
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.onCompanionSelected?(item)
            }
            .store(in: &cancellables)
    }

    // MARK: - Methods

    func stopRefreshing() {
        viewModel.action(.stop)
    }

    func updateLocation(_ coordinate: CLLocationCoordinate2D) {
        viewModel.action(.locationDidUpdate(coordinate))
    }

    func refreshCompanions() {
        viewModel.action(.refresh)
    }

    func specificCompanions(for placeId: Int) -> [SpecificCompanionCellItem] {
        viewModel.specificCompanions(for: placeId)
    }

    func updatePlaceCategory(_ category: CompanionPlace.Category) {
        viewModel.action(.placeCategoryDidSelect(category))
    }

    func updateNickname(_ nickname: String) {
        nearCompanionSheetView.updateNickname(nickname)
    }
}

// MARK: - UICollectionViewDataSource

extension NearCompanionSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isShowingSkeleton ? 3 : viewModel.nearCompanionCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(NearCompanionCell.self, for: indexPath)
        if isShowingSkeleton {
            cell.configureSkeleton()
        } else {
            cell.configure(with: viewModel.companion(at: indexPath.item))
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension NearCompanionSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !isShowingSkeleton else { return }
        viewModel.action(.companionDidSelect(indexPath.item))
    }
}
