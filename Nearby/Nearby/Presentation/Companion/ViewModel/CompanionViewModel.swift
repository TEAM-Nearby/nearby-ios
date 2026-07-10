//
//  CompanionViewModel.swift
//  Nearby
//
//  Created by soomin on 7/6/26.
//

import CoreFoundation
import Combine

final class CompanionViewModel: BaseViewModelType {
    
    // MARK: - Route
    
    enum Route {
        case recruitCompanion
        case companionDetail(CompanionDetailState)
    }
    
    // MARK: - Input
    
    enum Input {
        case recruitCompanionButtonDidTap
        case companionDidSelect(CompanionDetailState)
    }
    
    // MARK: - Output
    
    struct Output {
        let categoryItems: [CategoryItem]
        let mapConfiguration: CompanionMapConfiguration
    }
    
    // MARK: - Properties
    
    var route: ((Route) -> Void)?
    var output: Output
    
    // MARK: - Initializer
    
    init(
        categoryItems: [CategoryItem] = CategoryItem.categoryItems,
        mapConfiguration: CompanionMapConfiguration = .mock
    ) {
        self.output = Output(
            categoryItems: categoryItems,
            mapConfiguration: mapConfiguration
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .recruitCompanionButtonDidTap:
            route?(.recruitCompanion)
        case .companionDidSelect(let state):
            route?(.companionDetail(state))
        }
    }
}

private extension CompanionMapConfiguration {
    static let mock = CompanionMapConfiguration(
        initialZoom: 16.2,
        smallMarkerMaximumZoom: 14.0,
        largeMarkerMinimumZoom: 15.6,
        mediumMarkerSize: 24,
        smallMarkerSize: 10,
        markerItems: [
            CompanionMapMarkerItem(latitudeOffset: 0, longitudeOffset: 0.001, nickname: "수민이다", written: "30분 전", place: "장소명", date: "6월 18일 오후 4시 30분")
        ]
    )
}
