//
//  CompanionMapConfiguration.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import UIKit

enum MapMarkerStyle {
    case companion
    case restaurant
    case savedRestaurant
}

struct CompanionMapMarkerItem {
    let latitudeOffset: Double
    let longitudeOffset: Double
    let nickname: String
    let written: String
    let place: String
    let date: String
    let style: MapMarkerStyle

    init(latitudeOffset: Double, longitudeOffset: Double, nickname: String, written: String, place: String, date: String, style: MapMarkerStyle = .companion) {
        self.latitudeOffset = latitudeOffset
        self.longitudeOffset = longitudeOffset
        self.nickname = nickname
        self.written = written
        self.place = place
        self.date = date
        self.style = style
    }
}

struct CompanionMapConfiguration {
    let initialZoom: Float
    let smallMarkerMaximumZoom: Float
    let largeMarkerMinimumZoom: Float
    let mediumMarkerSize: CGFloat
    let smallMarkerSize: CGFloat
    let markerItems: [CompanionMapMarkerItem]
}
