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
        smallMarkerMaximumZoom: 14,
        largeMarkerMinimumZoom: 15.6,
        mediumMarkerSize: 24,
        smallMarkerSize: 10,
        markerItems: []
    )
}
