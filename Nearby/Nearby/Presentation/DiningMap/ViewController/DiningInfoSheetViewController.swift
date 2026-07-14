//
//  DiningInfoSheetViewController.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

import Combine
import UIKit

final class DiningInfoSheetViewController: BaseViewController<DiningInfoSheetViewModel> {
    
    // MARK: - Properties
    
    var onClose: (() -> Void)?
    var onBookmarkTap: (() -> Void)?

    private let diningInfoSheetView = DiningInfoSheetView()
    
    // MARK: - Life Cycles

    override func loadView() {
        view = diningInfoSheetView
    }

    override func bindAction() {
        diningInfoSheetView.onCloseTap = { [weak self] in
            self?.onClose?()
        }
        diningInfoSheetView.onBookmarkTap = { [weak self] in
            self?.viewModel.action(.bookmarkDidTap)
        }
    }

    override func bindState() {
        viewModel.output.restaurant
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.configureView(with: item)
            }
            .store(in: &cancellables)

        viewModel.output.bookmarkDidTap
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.onBookmarkTap?()
            }
            .store(in: &cancellables)

        viewModel.output.error
            .sink { error in
                AppLogger.error(error)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods

    private func configureView(with item: NearDiningCellItem) {
        diningInfoSheetView.configure(with: item, description: item.description,
                                      closingTime: item.closingTime, phoneNumber: item.phoneNumber, price: item.price)
    }

    func configure(with item: NearDiningCellItem) {
        loadViewIfNeeded()
        viewModel.action(.updateRestaurant(item))
    }
}
