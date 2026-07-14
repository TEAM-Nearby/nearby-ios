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
    let placeId: Int
    let coordinate: CLLocationCoordinate2D
    let nickname: String
    let written: String
    let place: String
    let date: String
    let style: MapMarkerStyle

    init(
        placeId: Int,
        coordinate: CLLocationCoordinate2D,
        nickname: String,
        written: String,
        place: String,
        date: String,
        style: MapMarkerStyle = .companion
    ) {
        self.placeId = placeId
        self.coordinate = coordinate
        self.nickname = nickname
        self.written = written
        self.place = place
        self.date = date
        self.style = style
    }
}

extension CompanionMapMarkerData {
    init(dto: CompanionDTO) {
        self.init(
            placeId: dto.place.placeId,
            coordinate: CLLocationCoordinate2D(latitude: dto.place.latitude, longitude: dto.place.longitude),
            nickname: dto.host.nickname,
            written: dto.createdAgoText,
            place: dto.place.name,
            date: dto.nearMeetingTimeTitle,
            style: .companion
        )
    }

    init?(diningItem: NearDiningCellItem) {
        guard
            let placeId = diningItem.placeId,
            let latitude = diningItem.latitude,
            let longitude = diningItem.longitude
        else { return nil }

        self.init(
            placeId: placeId,
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            nickname: diningItem.name,
            written: "",
            place: diningItem.name,
            date: "",
            style: .restaurant
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
