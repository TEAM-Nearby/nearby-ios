//
//  CompanionMapMarkerManager.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import CoreLocation
import GoogleMaps
import UIKit

final class CompanionMapMarkerManager {
    
    // MARK: - Properties
    
    private struct Content {
        let nickname: String
        let written: String
        let place: String
        let date: String
        let style: MapMarkerStyle
    }
    
    private struct Entry {
        let marker: GMSMarker
        let content: Content
        let placeId: Int?
    }
    
    // MARK: - UI Components
    
    private weak var mapView: GMSMapView?
    private var currentLocationMarkers: [GMSMarker] = []
    private var currentLocationDirectionMarker: GMSMarker?
    private var entries: [Entry] = []
    private var level: CompanionMarkerLevel
    private let configuration: CompanionMapConfiguration

    var hasCompanionMarkers: Bool {
        !entries.isEmpty
    }
    
    // MARK: - Initializer
    
    init(mapView: GMSMapView, configuration: CompanionMapConfiguration) {
        self.mapView = mapView
        self.configuration = configuration
        self.level = CompanionMarkerLevel(zoom: mapView.camera.zoom, configuration: configuration)
    }
    
    // MARK: - Methods
    
    private func applyAppearance(to marker: GMSMarker, content: Content, level: CompanionMarkerLevel) {
        marker.tracksViewChanges = true

        if content.style == .restaurant {
            marker.iconView = makeImageMarker(image: .icRestaurantMarker, size: configuration.mediumMarkerSize)
            marker.groundAnchor = CGPoint(x: 0.5, y: 1)
            stopTrackingViewChanges(for: marker)
            return
        }

        if content.style == .savedRestaurant {
            marker.iconView = makeImageMarker(image: .icStarHonbop, size: configuration.mediumMarkerSize)
            marker.groundAnchor = CGPoint(x: 0.5, y: 1)
            stopTrackingViewChanges(for: marker)
            return
        }
        
        switch level {
        case .large:
            let chipView = CompanionChipView()
            chipView.configure(nickname: content.nickname, written: content.written, place: content.place, date: content.date)
            chipView.frame = CGRect(origin: .zero, size: chipView.intrinsicContentSize)
            chipView.layoutIfNeeded()
            marker.iconView = chipView
            marker.groundAnchor = chipView.mapGroundAnchor
        case .medium:
            marker.iconView = makeImageMarker(image: .icRestaurantMarker, size: configuration.mediumMarkerSize)
            marker.groundAnchor = CGPoint(x: 0.5, y: 1)
        case .small:
            marker.iconView = makeImageMarker(image: .spot, size: configuration.smallMarkerSize)
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        }
        
        stopTrackingViewChanges(for: marker)
    }
    
    private func makeCurrentLocationMarkerView(image: UIImage, frame: CGRect) -> UIView {
        let markerView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let imageView = UIImageView(image: image)
        imageView.frame = frame
        imageView.contentMode = .scaleAspectFit
        markerView.addSubview(imageView)
        return markerView
    }

    private func makeCurrentLocationMarker(
        at coordinate: CLLocationCoordinate2D,
        image: UIImage,
        frame: CGRect,
        zIndex: Int32
    ) -> GMSMarker {
        let marker = GMSMarker(position: coordinate)
        marker.iconView = makeCurrentLocationMarkerView(image: image, frame: frame)
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        marker.zIndex = zIndex
        marker.tracksViewChanges = false
        marker.map = mapView
        return marker
    }
    
    private func makeImageMarker(image: UIImage, size: CGFloat) -> UIView {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    private func stopTrackingViewChanges(for marker: GMSMarker) {
        DispatchQueue.main.async {
            marker.tracksViewChanges = false
        }
    }
    
    func updateCurrentLocation(to location: CLLocation) {
        if !currentLocationMarkers.isEmpty {
            currentLocationMarkers.forEach { $0.position = location.coordinate }
            return
        }

        let backgroundMarker = makeCurrentLocationMarker(
            at: location.coordinate,
            image: .markerMyLocationBg,
            frame: CGRect(x: 0, y: 0, width: 50, height: 50),
            zIndex: 1_000
        )
        let directionMarker = makeCurrentLocationMarker(
            at: location.coordinate,
            image: .markerMyLocationArrow,
            frame: CGRect(x: 13, y: 0, width: 24, height: 24),
            zIndex: 1_001
        )
        let profileMarker = makeCurrentLocationMarker(
            at: location.coordinate,
            image: .markerMyLocationProfile,
            frame: CGRect(x: 10, y: 10, width: 30, height: 30),
            zIndex: 1_002
        )

        currentLocationMarkers = [backgroundMarker, directionMarker, profileMarker]
        currentLocationDirectionMarker = directionMarker
    }
    
    @discardableResult
    func addCompanionMarker(at coordinate: CLLocationCoordinate2D, placeId: Int? = nil, nickname: String,
                            written: String, place: String, date: String, style: MapMarkerStyle = .companion) -> GMSMarker {
        let content = Content(nickname: nickname, written: written, place: place, date: date, style: style)
        let marker = GMSMarker(position: coordinate)
        applyAppearance(to: marker, content: content, level: level)
        marker.map = mapView
        entries.append(Entry(marker: marker, content: content, placeId: placeId))
        return marker
    }

    func replaceCompanionMarkers(with items: [CompanionMapMarkerData]) {
        entries
            .filter { $0.content.style == .companion }
            .forEach { $0.marker.map = nil }
        entries.removeAll { $0.content.style == .companion }

        items.forEach { item in
            addCompanionMarker(at: item.coordinate, placeId: item.placeId,
                               nickname: item.nickname, written: item.written,
                               place: item.place, date: item.date, style: item.style)
        }
    }

    func replaceDiningMarkers(with items: [CompanionMapMarkerData]) {
        entries
            .filter { $0.content.style != .companion }
            .forEach { $0.marker.map = nil }
        entries.removeAll { $0.content.style != .companion }

        items.forEach { item in
            addCompanionMarker(at: item.coordinate, placeId: item.placeId,
                               nickname: item.nickname, written: item.written,
                               place: item.place, date: item.date, style: item.style)
        }
    }
    
    func updateLevel(for zoom: Float) {
        let newLevel = CompanionMarkerLevel(zoom: zoom, configuration: configuration)
        guard newLevel != level else { return }
        
        level = newLevel
        entries.forEach { applyAppearance(to: $0.marker, content: $0.content, level: newLevel) }
    }
    
    func containsCompanionMarker(_ marker: GMSMarker) -> Bool {
        entries.contains { $0.marker === marker }
    }

    func placeId(for marker: GMSMarker) -> Int? {
        entries.first { $0.marker === marker }?.placeId
    }
    
    func updateHeading(_ heading: CLHeading) {
        guard heading.headingAccuracy >= 0 else { return }

        let degree = heading.trueHeading >= 0 ? heading.trueHeading : heading.magneticHeading
        guard degree >= 0 else { return }

        currentLocationDirectionMarker?.rotation = degree
    }
}
