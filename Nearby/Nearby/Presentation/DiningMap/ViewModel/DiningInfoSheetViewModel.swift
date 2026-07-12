//
//  DiningInfoSheetViewModel.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

import Combine

final class DiningInfoSheetViewModel: BaseViewModelType {
    
    // MARK: - Input

    enum Input {
        case updateRestaurant(NearDiningCellItem)
        case bookmarkDidTap
    }
    
    // MARK: - Output

    struct Output {
        let restaurant = CurrentValueSubject<NearDiningCellItem?, Never>(nil)
        let bookmarkDidTap = PassthroughSubject<Void, Never>()
    }
    
    // MARK: - Propety

    let output = Output()
    
    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .updateRestaurant(let item):
            output.restaurant.send(item)
        case .bookmarkDidTap:
            guard var item = output.restaurant.value else { return }
            item.isBookmarked.toggle()
            output.restaurant.send(item)
            output.bookmarkDidTap.send(())
        }
    }
}
