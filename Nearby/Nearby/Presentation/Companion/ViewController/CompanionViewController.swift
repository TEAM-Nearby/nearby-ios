//
//  CompanionViewController.swift
//  Nearby
//
//  Created by soomin on 7/6/26.
//

import UIKit

import CoreLocation
import GoogleMaps
import SnapKit

final class CompanionViewController: BaseViewController<CompanionViewModel> {
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    private var mapView: GMSMapView?
    private var currentLocation: CLLocation?
    private var currentLocationMarker: GMSMarker?
    private weak var currentLocationDirectionView: UIView?
    private var categoryItems: [CategoryItem] {
        viewModel.output.categoryItems
    }
    
    private var contentView: CompanionView {
        guard let view = view as? CompanionView else {
            fatalError("CompanionViewController view is not CompanionView")
        }
        return view
    }
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = CompanionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapView()
        configureLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Custom Methods
    
    override func setAddTarget() {
        contentView.currentLocationButton.addTarget(self, action: #selector(currentLocationButtonDidTap), for: .touchUpInside)
        contentView.recruitCompanionButton.addTarget(self, action: #selector(recruitCompanionButtonDidTap), for: .touchUpInside)
    }
    
    override func setDelegate() {
        contentView.categoryCollectionView.dataSource = self
        contentView.categoryCollectionView.delegate = self
    }
    
    // MARK: - Methods
    
    private func configureMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: 37.531821, longitude: 126.913904, zoom: 15.0)
        
        let options = GMSMapViewOptions()
        options.camera = camera
        options.frame = contentView.mapContainerView.bounds
        
        let mapView = GMSMapView(options: options)
        mapView.isMyLocationEnabled = false
        mapView.settings.myLocationButton = false
        
        contentView.mapContainerView.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.mapView = mapView
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
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
    
    private func moveCamera(to location: CLLocation) {
        let camera = GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: 16.0
        )
        mapView?.animate(to: camera)
    }
    
    private func updateCurrentLocationMarker(to location: CLLocation) {
        let coordinate = location.coordinate
        
        if let currentLocationMarker {
            currentLocationMarker.position = coordinate
            return
        }
        
        let marker = GMSMarker(position: coordinate)
        marker.iconView = makeCurrentLocationMarkerView()
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        marker.map = mapView
        marker.tracksViewChanges = true
        currentLocationMarker = marker
    }

    private func makeCurrentLocationMarkerView() -> UIView {
        let markerView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        let backgroundImageView = UIImageView(image: .markerMyLocationBg)
        backgroundImageView.frame = markerView.bounds

        let directionView = UIView(frame: markerView.bounds)
        
        let arrowImageView = UIImageView(image: .markerMyLocationArrow)
        arrowImageView.frame = CGRect(x: 13, y: 0, width: 24, height: 24)
        
        let profileImageView = UIImageView(image: .markerMyLocationProfile)
        profileImageView.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        
        directionView.addSubviews(arrowImageView, profileImageView)
        markerView.addSubviews(backgroundImageView, directionView)
        currentLocationDirectionView = directionView
        return markerView
    }

    private func startUpdatingHeadingIfNeeded() {
        guard CLLocationManager.headingAvailable() else { return }
        locationManager.headingFilter = 1
        locationManager.startUpdatingHeading()
    }

    private func updateCurrentLocationHeading(_ heading: CLHeading) {
        let headingDegree = heading.trueHeading >= 0 ? heading.trueHeading : heading.magneticHeading
        let headingRadian = CGFloat(headingDegree * .pi / 180)
        
        currentLocationDirectionView?.transform = CGAffineTransform(rotationAngle: headingRadian)
        currentLocationMarker?.tracksViewChanges = true
    }
    
    // MARK: - Action
    
    @objc
    private func currentLocationButtonDidTap() {
        if let currentLocation {
            moveCamera(to: currentLocation)
            return
        }
        
        locationManager.requestLocation()
    }
    
    @objc
    private func recruitCompanionButtonDidTap() {
        viewModel.action(.recruitCompanionButtonDidTap)
    }
}

// MARK: - UICollectionViewDataSource

extension CompanionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryItems.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(NearbyChipCollectionViewCell.self, for: indexPath)
        let item = categoryItems[indexPath.item]
        
        cell.configure(style: .category, title: item.title, icon: item.icon, iconColor: item.iconColor)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CompanionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let item = categoryItems[indexPath.item]
        let titleWidth = (item.title as NSString).size(withAttributes: [.font: NearbyChipStyle.category.font]).width
        let iconWidth: CGFloat = 24
        let horizontalInset: CGFloat = 24
        
        return CGSize(
            width: ceil(titleWidth + iconWidth + horizontalInset),
            height: NearbyChipStyle.category.height
        )
    }
}

// MARK: - CLLocationManagerDelegate

extension CompanionViewController: CLLocationManagerDelegate {
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
        currentLocation = location
        updateCurrentLocationMarker(to: location)
        moveCamera(to: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AppLogger.error(error)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        updateCurrentLocationHeading(newHeading)
    }
}
