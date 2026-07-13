//
//  CompanionMapController.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import CoreLocation
import GoogleMaps

final class CompanionMapController: NSObject {
    
    // MARK: - Properties
    
    var onCompanionMarkerTap: (() -> Void)?
    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?

    private let locationManager = CLLocationManager()
    private let mapView: GMSMapView
    private let markerManager: CompanionMapMarkerManager
    private let configuration: CompanionMapConfiguration
    private var currentLocation: CLLocation?
    
    // MARK: - Initializer

    init(mapView: GMSMapView, configuration: CompanionMapConfiguration) {
        self.mapView = mapView
        self.configuration = configuration
        self.markerManager = CompanionMapMarkerManager(mapView: mapView, configuration: configuration)
        super.init()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        if let referenceCoordinate = configuration.referenceCoordinate {
            moveCamera(to: CLLocation(
                latitude: referenceCoordinate.latitude,
                longitude: referenceCoordinate.longitude
            ))
        }
    }
    
    // MARK: - Methods
    
    private func moveCamera(to location: CLLocation) {
        let camera = GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: configuration.initialZoom
        )
        mapView.animate(to: camera)
    }

    private func startUpdatingHeadingIfNeeded() {
        guard CLLocationManager.headingAvailable() else { return }
        locationManager.headingFilter = 1
        locationManager.startUpdatingHeading()
    }

    private func addConfiguredMarkersIfNeeded(near location: CLLocation) {
        guard !markerManager.hasCompanionMarkers else { return }
        configuration.markerItems.forEach { item in
            let coordinate = CLLocationCoordinate2D(
                latitude: location.coordinate.latitude + item.latitudeOffset,
                longitude: location.coordinate.longitude + item.longitudeOffset
            )
            addCompanionMarker(at: coordinate, nickname: item.nickname, written: item.written, place: item.place, date: item.date, style: item.style)
        }
    }

    func start() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
            startUpdatingHeadingIfNeeded()
        case .denied, .restricted:
            break
        @unknown default:
            break
        }
    }

    func stop() {
        locationManager.stopUpdatingHeading()
    }

    func moveToCurrentLocation() {
        guard let currentLocation else {
            locationManager.requestLocation()
            return
        }
        moveCamera(to: currentLocation)
    }

    @discardableResult
    func addCompanionMarker(at coordinate: CLLocationCoordinate2D, nickname: String, written: String, place: String, date: String, style: MapMarkerStyle = .companion) -> GMSMarker {
        markerManager.addCompanionMarker(at: coordinate, nickname: nickname, written: written, place: place, date: date, style: style)
    }

    func updateCompanionMarkers(_ markers: [CompanionMapMarkerData]) {
        markerManager.replaceCompanionMarkers(with: markers)
    }
}

// MARK: - GMSMapViewDelegate

extension CompanionMapController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        markerManager.updateLevel(for: position.zoom)
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard markerManager.containsCompanionMarker(marker) else { return false }
        onCompanionMarkerTap?()
        return true
    }
}

// MARK: - CLLocationManagerDelegate

extension CompanionMapController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
            startUpdatingHeadingIfNeeded()
        case .notDetermined, .denied, .restricted:
            break
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let displayedLocation = configuration.referenceCoordinate.map {
            CLLocation(latitude: $0.latitude, longitude: $0.longitude)
        } ?? location

        currentLocation = displayedLocation
        onLocationUpdate?(displayedLocation.coordinate)
        markerManager.updateCurrentLocation(to: displayedLocation)
        moveCamera(to: displayedLocation)
        addConfiguredMarkersIfNeeded(near: displayedLocation)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AppLogger.error(error)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        markerManager.updateHeading(newHeading)
    }
}
