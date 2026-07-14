//
//  DiningMapViewModel.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import Combine
import CoreLocation

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
        referenceCoordinate: CLLocationCoordinate2D(latitude: 41.389458, longitude: 2.168289),
        initialZoom: 16.2,
        smallMarkerMaximumZoom: -1,
        largeMarkerMinimumZoom: 100,
        mediumMarkerSize: 24,
        smallMarkerSize: 10,
        markerItems: []
    )
}
