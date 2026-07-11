//
//  CompanionMarkerLevel.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

enum CompanionMarkerLevel: Equatable {
    case small
    case medium
    case large

    init(zoom: Float, configuration: CompanionMapConfiguration) {
        switch zoom {
        case ..<configuration.smallMarkerMaximumZoom:
            self = .small
        case configuration.smallMarkerMaximumZoom..<configuration.largeMarkerMinimumZoom:
            self = .medium
        default:
            self = .large
        }
    }
}
