//
//  NearCompanionBottomSheetViewController.swift
//  Nearby
//
//  Created by soomin on 7/8/26.
//

import UIKit
import Combine

final class NearCompanionBottomSheetViewController: BaseViewController<NearCompanionBottomSheetViewModel> {
    
    // MARK: - Properties

    var onCompanionSelected: ((NearCompanionCellItem) -> Void)?
    
    private var nearCompanionBottomSheetView = NearCompanionBottomSheetView(sortOptions: SortOption.allCases)
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = nearCompanionBottomSheetView
    }
    
    // MARK: - Custom Methods

    override func setDelegate() {
        nearCompanionBottomSheetView.collectionView.dataSource = self
        nearCompanionBottomSheetView.collectionView.delegate = self
    }

    override func bindAction() {
        nearCompanionBottomSheetView.sortOptionDidTap = { [weak self] option in
            self?.viewModel.action(.sortOptionDidTap(option))
        }
    }
    
    override func bindState() {
        viewModel.output.selectedSortOption
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedOption in
                self?.nearCompanionBottomSheetView.updateSortButtonSelection(selectedOption)
            }
            .store(in: &cancellables)

        viewModel.output.companions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.nearCompanionBottomSheetView.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.output.selectedCompanion
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.onCompanionSelected?(item)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource

extension NearCompanionBottomSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.nearCompanionCount
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(NearCompanionCell.self, for: indexPath)
        cell.configure(with: viewModel.companion(at: indexPath.item))
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension NearCompanionBottomSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.action(.companionDidSelect(indexPath.item))
    }
}
