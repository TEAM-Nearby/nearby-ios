//
//  CompanionViewModel.swift
//  Nearby
//
//  Created by soomin on 7/6/26.
//

import Combine

final class CompanionViewModel: BaseViewModelType {
    
    // MARK: - Route
    
    enum Route {
        case recruitCompanion
    }
    
    // MARK: - Input
    
    enum Input {
        case recruitCompanionButtonDidTap
    }
    
    // MARK: - Output
    
    struct Output {
        let categoryItems: [CategoryItem]
    }
    
    // MARK: - Properties
    
    var route: ((Route) -> Void)?
    var output: Output
    
    // MARK: - Initializer
    
    init() {
        self.output = Output(
            categoryItems: CategoryItem.categoryItems
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .recruitCompanionButtonDidTap:
            route?(.recruitCompanion)
        }
    }
}
