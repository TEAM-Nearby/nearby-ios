//
//  DiningMapViewModel.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import Combine
import CoreFoundation

final class DiningMapViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case bookmarkDidTap
    }

    // MARK: - Output
    
    struct Output {
        let mapConfiguration: CompanionMapConfiguration
        let isBookmarkSelected = CurrentValueSubject<Bool, Never>(false)
    }
    
    // MARK: - Property

    let output: Output

    // MARK: - Initializer
    
    init(mapConfiguration: CompanionMapConfiguration = .diningMap) {
        self.output = Output(mapConfiguration: mapConfiguration)
    }

    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .bookmarkDidTap:
            output.isBookmarkSelected.send(!output.isBookmarkSelected.value)
        }
    }
}

private extension CompanionMapConfiguration {
    static let diningMap = CompanionMapConfiguration(
        initialZoom: 16.2,
        smallMarkerMaximumZoom: -1,
        largeMarkerMinimumZoom: 100,
        mediumMarkerSize: 24,
        smallMarkerSize: 10,
        markerItems: [
            CompanionMapMarkerItem(latitudeOffset: 0, longitudeOffset: 0.001, nickname: "일반 식당 1", written: "", place: "", date: "", style: .restaurant),
            CompanionMapMarkerItem(latitudeOffset: 0.0007, longitudeOffset: -0.0007, nickname: "일반 식당 2", written: "", place: "", date: "", style: .restaurant),
            CompanionMapMarkerItem(latitudeOffset: -0.0007, longitudeOffset: -0.0007, nickname: "저장 식당", written: "", place: "", date: "", style: .savedRestaurant)
        ]
    )
}
