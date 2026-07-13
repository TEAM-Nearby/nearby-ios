//
//  CompanionMapConfiguration.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import CoreLocation
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

struct CompanionMapMarkerData {
    let coordinate: CLLocationCoordinate2D
    let nickname: String
    let written: String
    let place: String
    let date: String
}

extension CompanionMapMarkerData {
    init(dto: CompanionDTO) {
        self.init(coordinate: CLLocationCoordinate2D(
                latitude: dto.place.latitude,
                longitude: dto.place.longitude
            ),
            nickname: dto.host.nickname,
            written: dto.createdAgoText,
            place: dto.place.name,
            date: dto.meetingAtText
        )
    }
}

struct CompanionMapConfiguration {
    let referenceCoordinate: CLLocationCoordinate2D?
    let initialZoom: Float
    let smallMarkerMaximumZoom: Float
    let largeMarkerMinimumZoom: Float
    let mediumMarkerSize: CGFloat
    let smallMarkerSize: CGFloat
    let markerItems: [CompanionMapMarkerItem]

    init(
        referenceCoordinate: CLLocationCoordinate2D? = nil,
        initialZoom: Float,
        smallMarkerMaximumZoom: Float,
        largeMarkerMinimumZoom: Float,
        mediumMarkerSize: CGFloat,
        smallMarkerSize: CGFloat,
        markerItems: [CompanionMapMarkerItem]
    ) {
        self.referenceCoordinate = referenceCoordinate
        self.initialZoom = initialZoom
        self.smallMarkerMaximumZoom = smallMarkerMaximumZoom
        self.largeMarkerMinimumZoom = largeMarkerMinimumZoom
        self.mediumMarkerSize = mediumMarkerSize
        self.smallMarkerSize = smallMarkerSize
        self.markerItems = markerItems
    }
}
