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
    }
    
    // MARK: - Method

    func configure(with item: NearDiningCellItem) {
        loadViewIfNeeded()
        viewModel.action(.updateRestaurant(item))
    }

    private func configureView(with item: NearDiningCellItem) {
        diningInfoSheetView.configure(
            with: item,
            description: "다양한 종류의 우아한 가구와 넓은 야외 좌석이 있는 넓고 유명한 타파스 바입니다.",
            closingTime: "오전 1시에 영업 종료",
            phoneNumber: "+34 933 18 19 97",
            price: "$20~30"
        )
    }
}
