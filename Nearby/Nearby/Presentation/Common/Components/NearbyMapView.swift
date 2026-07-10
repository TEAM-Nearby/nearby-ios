//
//  NearbyMapView.swift
//  Nearby
//
//  Created by 장지인 on 7/10/26.
//

import UIKit

import GoogleMaps
import SnapKit
import Then

final class NearbyMapView: BaseView {

    // MARK: - UI Components

    private let mapView = GMSMapView()
    private let marker = GMSMarker()
    private let markerImageView = UIImageView()

    // MARK: - Custom Methods

    override func setStyle() {
        mapView.do {
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }

        markerImageView.do {
            $0.image = .smallLocationBlackIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .primary50
            $0.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            $0.contentMode = .scaleAspectFit
        }
    }

    override func setUI() {
        addSubview(mapView)
    }

    override func setLayout() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension NearbyMapView {
    func configure(latitude: Double, longitude: Double, zoom: Float = 16.0) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: zoom)

        mapView.camera = camera

        marker.position = coordinate
        marker.iconView = markerImageView
        marker.map = mapView
    }
}
