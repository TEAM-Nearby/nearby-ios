//
//  SpecificCompanionSheetViewController.swift
//  Nearby
//
//  Created by soomin on 7/8/26.
//

import UIKit
import Combine

final class SpecificCompanionBottomSheetViewController: BaseViewController<SpecificCompanionBottomSheetViewModel> {
    
    // MARK: - Property
    
    private let specificCompanionBottomSheetView = SpecificCompanionBottomSheetView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = specificCompanionBottomSheetView
    }
    
    // MARK: - Custom Methods
    
    override func setDelegate() {
        specificCompanionBottomSheetView.collectionView.dataSource = self
    }
    
    override func bindState() {
        viewModel.output.companions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.specificCompanionBottomSheetView.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource

extension SpecificCompanionBottomSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.companionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(SpecificCompanionCell.self, for: indexPath)
        cell.configure(with: viewModel.companion(at: indexPath.item))
        return cell
    }
}
