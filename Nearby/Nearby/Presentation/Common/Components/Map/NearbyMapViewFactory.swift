//
//  NearbyMapViewFactory.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import GoogleMaps

enum NearbyMapViewFactory {
    
    // MARK: - Methods
    
    static func makeMapView() -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: 37.531821, longitude: 126.913904, zoom: 15)
        let options = GMSMapViewOptions()
        options.camera = camera
        
        let mapView = GMSMapView(options: options)
        mapView.isMyLocationEnabled = false
        mapView.settings.myLocationButton = false
        return mapView
    }
}
