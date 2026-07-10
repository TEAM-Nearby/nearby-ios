//
//  CompanionMapConfiguration.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import UIKit

struct CompanionMapMarkerItem {
    let latitudeOffset: Double
    let longitudeOffset: Double
    let nickname: String
    let written: String
    let place: String
    let date: String
}

struct CompanionMapConfiguration {
    let initialZoom: Float
    let smallMarkerMaximumZoom: Float
    let largeMarkerMinimumZoom: Float
    let mediumMarkerSize: CGFloat
    let smallMarkerSize: CGFloat
    let markerItems: [CompanionMapMarkerItem]
}
