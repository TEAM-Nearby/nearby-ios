//
//  SpecificCompanionSheetViewController.swift
//  Nearby
//
//  Created by soomin on 7/8/26.
//

import Combine
import UIKit

final class SpecificCompanionSheetViewController: BaseViewController<SpecificCompanionSheetViewModel> {
    
    // MARK: - Properties
    
    private let specificCompanionSheetView = SpecificCompanionSheetView()
    var onClose: (() -> Void)?
    var onCompanionSelected: ((SpecificCompanionCellItem) -> Void)?
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = specificCompanionSheetView
    }
    
    // MARK: - Custom Methods
    
    override func setDelegate() {
        specificCompanionSheetView.collectionView.dataSource = self
        specificCompanionSheetView.collectionView.delegate = self
    }

    override func setAddTarget() {
        specificCompanionSheetView.closeButton.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
    }
    
    override func bindState() {
        viewModel.output.companions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.specificCompanionSheetView.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }

    // MARK: - Action

    @objc
    private func closeButtonDidTap() {
        onClose?()
    }
}

// MARK: - UICollectionViewDelegate

extension SpecificCompanionSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onCompanionSelected?(viewModel.companion(at: indexPath.item))
    }
}

// MARK: - UICollectionViewDataSource

extension SpecificCompanionSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.companionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(SpecificCompanionCell.self, for: indexPath)
        cell.configure(with: viewModel.companion(at: indexPath.item))
        return cell
    }
}
