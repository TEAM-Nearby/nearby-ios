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
    
    var onMarkerTap: ((Int) -> Void)?
    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?

    private let locationManager = CLLocationManager()
    private let mapView: GMSMapView
    private let markerManager: CompanionMapMarkerManager
    private let configuration: CompanionMapConfiguration
    private var currentCoordinate: CLLocationCoordinate2D?
    private let cameraVerticalOffset: CGFloat = 38
    
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
            moveCamera(to: referenceCoordinate)
        }
    }
    
    // MARK: - Methods
    
    private func moveCamera(to coordinate: CLLocationCoordinate2D) {
        let target = cameraTarget(for: coordinate, zoom: configuration.initialZoom, verticalOffset: cameraVerticalOffset)
        let camera = GMSCameraPosition.camera(withLatitude: target.latitude, longitude: target.longitude, zoom: configuration.initialZoom)
        mapView.animate(to: camera)
    }

    private func cameraTarget(for coordinate: CLLocationCoordinate2D, zoom: Float, verticalOffset: CGFloat) -> CLLocationCoordinate2D {
        let worldSize = 256 * pow(2, Double(zoom))
        let latitudeRadians = coordinate.latitude * .pi / 180
        let mercatorY = (1 - log(tan(latitudeRadians) + 1 / cos(latitudeRadians)) / .pi) / 2
        let offsetMercatorY = mercatorY + Double(verticalOffset) / worldSize
        let latitude = atan(sinh(.pi * (1 - 2 * offsetMercatorY))) * 180 / .pi

        return CLLocationCoordinate2D(latitude: latitude, longitude: coordinate.longitude)
    }

    private func startUpdatingHeadingIfNeeded() {
        guard CLLocationManager.headingAvailable() else { return }
        locationManager.headingFilter = 3
        locationManager.startUpdatingHeading()
    }

    private func requestLocation() {
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

    func start() {
        requestLocation()
    }

    func stop() {
        locationManager.stopUpdatingHeading()
    }

    func moveToCurrentLocation() {
        guard let currentCoordinate else {
            requestLocation()
            return
        }
        moveCamera(to: currentCoordinate)
    }

    func updateCompanionMarkers(_ markers: [CompanionMapMarkerData]) {
        markerManager.replaceCompanionMarkers(with: markers)
    }

    func updateDiningMarkers(_ markers: [CompanionMapMarkerData]) {
        markerManager.replaceDiningMarkers(with: markers)
    }
}

// MARK: - GMSMapViewDelegate

extension CompanionMapController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        markerManager.updateLevel(for: position.zoom)
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let placeId = markerManager.placeId(for: marker) else { return false }
        onMarkerTap?(placeId)
        return true
    }
}

// MARK: - CLLocationManagerDelegate

extension CompanionMapController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let displayedCoordinate = configuration.referenceCoordinate ?? location.coordinate

        currentCoordinate = displayedCoordinate
        onLocationUpdate?(displayedCoordinate)
        markerManager.updateCurrentLocation(to: displayedCoordinate)
        moveCamera(to: displayedCoordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AppLogger.error(error)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        markerManager.updateHeading(newHeading)
    }
}
