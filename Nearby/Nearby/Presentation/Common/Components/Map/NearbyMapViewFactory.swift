//
//  NearbyMapViewFactory.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import GoogleMaps

enum NearbyMapViewFactory {
    
    // MARK: - Method
    
    static func makeMapView(initialCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.531821, longitude: 126.913904)) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: initialCoordinate.latitude, longitude: initialCoordinate.longitude, zoom: 15)
        let options = GMSMapViewOptions()
        options.camera = camera
        
        let mapView = GMSMapView(options: options)
        mapView.overrideUserInterfaceStyle = .light
        mapView.isMyLocationEnabled = false
        mapView.settings.myLocationButton = false
        mapView.settings.rotateGestures = false
        mapView.settings.compassButton = false
        return mapView
    }
}
