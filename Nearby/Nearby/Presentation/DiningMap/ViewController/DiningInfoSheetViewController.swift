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
    
    var onEvent: ((DiningMapSheetEvent) -> Void)?

    private let initialLoadingTracker = InitialLoadingTracker()
    private let diningInfoSheetView = DiningInfoSheetView()
    
    // MARK: - Life Cycles

    override func loadView() {
        view = diningInfoSheetView
    }
    
    // MARK: - Custom Methods

    override func bindAction() {
        diningInfoSheetView.onCloseTap = { [weak self] in
            self?.onEvent?(.closeDetail)
        }
        diningInfoSheetView.onBookmarkTap = { [weak self] in
            self?.viewModel.action(.bookmarkDidTap)
        }
    }

    override func bindState() {
        viewModel.output.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .idle:
                    break
                case .loading(let item):
                    configureView(with: item)
                case .loaded(let item):
                    initialLoadingTracker.complete(in: self)
                    configureView(with: item)
                case .failed(let error):
                    initialLoadingTracker.complete(in: self)
                    AppLogger.error(error)
                }
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

    private func configureView(with item: NearDiningCellItem) {
        diningInfoSheetView.configure(with: item, description: item.description, closingTime: item.closingTime,
                                      phoneNumber: item.phoneNumber, price: item.price)
    }

    func configure(with item: NearDiningCellItem) {
        loadViewIfNeeded()
        viewModel.action(.updateRestaurant(item))
        if item.placeId != nil {
            initialLoadingTracker.begin(in: self)
        }
    }
}
