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

    // MARK: - Properties

    private let cornerRadius: CGFloat
    private let markerSize: CGSize

    // MARK: - UI Components

    private let mapView = GMSMapView()
    private let marker = GMSMarker()
    private let markerImageView = UIImageView()

    // MARK: - Initializer

    init(
        cornerRadius: CGFloat = 16,
        markerSize: CGSize = CGSize(width: 30, height: 30)
    ) {
        self.cornerRadius = cornerRadius
        self.markerSize = markerSize
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    override func setStyle() {
        mapView.do {
            $0.layer.cornerRadius = cornerRadius
            $0.clipsToBounds = true
        }

        markerImageView.do {
            $0.image = .smallLocationBlackIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .primary50
            $0.frame = CGRect(origin: .zero, size: markerSize)
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

    // MARK: - Method

    func configure(latitude: Double, longitude: Double, zoom: Float = 16.0) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: zoom)

        mapView.camera = camera

        marker.position = coordinate
        marker.iconView = markerImageView
        marker.map = mapView
    }
}
