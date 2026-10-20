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

    var onInitialMapReady: (() -> Void)?

    private let initialFallbackCoordinate: CLLocationCoordinate2D?
    private var hasResolvedInitialLocation = false
    private var hasCompletedInitialMap = false
    private var isRunning = false
    private var locationTimeoutTask: Task<Void, Never>?
    private var renderingTimeoutTask: Task<Void, Never>?
    private let locationManager = CLLocationManager()
    private let mapView: GMSMapView
    private let markerManager: CompanionMapMarkerManager
    private let configuration: CompanionMapConfiguration
    private var currentCoordinate: CLLocationCoordinate2D?
    private let cameraVerticalOffset: CGFloat = 38
    
    // MARK: - Initializer

    init(mapView: GMSMapView, configuration: CompanionMapConfiguration, initialFallbackCoordinate: CLLocationCoordinate2D? = nil) {
        self.initialFallbackCoordinate = initialFallbackCoordinate
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
    
    private func moveCamera(to coordinate: CLLocationCoordinate2D, animated: Bool = true) {
        let target = cameraTarget(for: coordinate, zoom: configuration.initialZoom, verticalOffset: cameraVerticalOffset)
        let camera = GMSCameraPosition.camera(withLatitude: target.latitude, longitude: target.longitude, zoom: configuration.initialZoom)
        if animated {
            mapView.animate(to: camera)
        } else {
            mapView.camera = camera
        }
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

    private func resolveInitialLocation(using coordinate: CLLocationCoordinate2D) {
        hasResolvedInitialLocation = true
        locationTimeoutTask?.cancel()
        moveCamera(to: coordinate, animated: false)
        waitForInitialMap()
    }

    private func useFallbackLocationIfNeeded() {
        guard !hasResolvedInitialLocation, let initialFallbackCoordinate else { return }
        resolveInitialLocation(using: initialFallbackCoordinate)
    }

    private func waitForInitialMap() {
        guard initialFallbackCoordinate != nil, !hasCompletedInitialMap else { return }
        renderingTimeoutTask?.cancel()
        renderingTimeoutTask = Task { [weak self] in
            do { try await Task.sleep(for: .seconds(8)) } catch { return }
            self?.completeInitialMap()
        }
    }

    private func completeInitialMap() {
        guard hasResolvedInitialLocation, !hasCompletedInitialMap else { return }
        hasCompletedInitialMap = true
        renderingTimeoutTask?.cancel()
        onInitialMapReady?()
    }

    private func requestLocation() {
        guard isRunning else { return }
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            if initialFallbackCoordinate != nil, !hasResolvedInitialLocation, locationTimeoutTask == nil {
                locationTimeoutTask = Task { [weak self] in
                    do { try await Task.sleep(for: .seconds(10)) } catch { return }
                    self?.useFallbackLocationIfNeeded()
                }
            }
            locationManager.requestLocation()
            startUpdatingHeadingIfNeeded()
        case .denied, .restricted:
            useFallbackLocationIfNeeded()
        @unknown default:
            useFallbackLocationIfNeeded()
        }
    }

    private func updateCurrentLocation(to coordinate: CLLocationCoordinate2D) {
        if let currentCoordinate,
           currentCoordinate.latitude == coordinate.latitude,
           currentCoordinate.longitude == coordinate.longitude { return }

        currentCoordinate = coordinate
        if initialFallbackCoordinate != nil, !hasCompletedInitialMap {
            resolveInitialLocation(using: coordinate)
        } else {
            moveCamera(to: coordinate)
        }
        onLocationUpdate?(coordinate)
        markerManager.updateCurrentLocation(to: coordinate)
    }

    func start() {
        isRunning = true
        if hasResolvedInitialLocation, !hasCompletedInitialMap { waitForInitialMap() }
        if let referenceCoordinate = configuration.referenceCoordinate {
            updateCurrentLocation(to: referenceCoordinate)
        }
        requestLocation()
    }

    func stop() {
        isRunning = false
        locationTimeoutTask?.cancel()
        locationTimeoutTask = nil
        renderingTimeoutTask?.cancel()
        locationManager.stopUpdatingLocation()
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
    func mapViewSnapshotReady(_ mapView: GMSMapView) {
        guard isRunning else { return }
        completeInitialMap()
    }

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
        guard isRunning, let location = locations.last else { return }
        let displayedCoordinate = configuration.referenceCoordinate ?? location.coordinate

        updateCurrentLocation(to: displayedCoordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AppLogger.error(error)
        guard isRunning else { return }
        useFallbackLocationIfNeeded()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        markerManager.updateHeading(newHeading)
    }
}
