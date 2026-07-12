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
    
    private var latitude: Double?
    private var longitude: Double?
    private var placeName: String?
    private var placeID: String?
    
    var onMapDidTap: ((_ latitude: Double, _ longitude: Double) -> Void)?

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
            $0.delegate = self
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

    // MARK: - Methods
    
    private func openGoogleMaps() {
        guard let latitude, let longitude else { return }

        if let onMapDidTap {
            onMapDidTap(latitude, longitude)
            return
        }

        let name = placeName?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        var urlString = "https://www.google.com/maps/search/?api=1&query="
        urlString += name.isEmpty ? "\(latitude),\(longitude)" : "\(name)%20\(latitude),\(longitude)"
        if let placeID {
            urlString += "&query_place_id=\(placeID)"
        }
        guard let url = URL(string: urlString) else { return }

        owningViewController?.presentSafariViewController(url: url, asBottomSheet: true)
    }
    
    func configure(latitude: Double, longitude: Double, placeName: String? = nil, placeID: String? = nil, zoom: Float = 16.0, showsInfoWindow: Bool = false) {
        self.latitude = latitude
        self.longitude = longitude
        self.placeName = placeName
        self.placeID = placeID
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: zoom)

        mapView.camera = camera

        marker.position = coordinate
        marker.title = placeName
        marker.iconView = markerImageView
        marker.map = mapView
        
        if showsInfoWindow {
            mapView.selectedMarker = marker
        }
    }
}

// MARK: - GMSMapViewDelegate

extension NearbyMapView: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        openGoogleMaps()
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        openGoogleMaps()
        return true
    }
}

// MARK: - Responder Chain

private extension UIView {
    var owningViewController: UIViewController? {
        var responder: UIResponder? = next
        while let current = responder {
            if let viewController = current as? UIViewController { return viewController }
            responder = current.next
        }
        return nil
    }
}
