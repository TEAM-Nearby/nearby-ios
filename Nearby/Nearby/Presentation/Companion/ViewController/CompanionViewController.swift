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
    private var currentLocation: CLLocation?
    private var currentLocationMarker: GMSMarker?
    
    // MARK: - UI Components
    
    private let bottomSheetViewController = NearbyBottomSheetViewController()
    private let nearbyBottomSheetViewController: UIViewController
    private let specificBottomSheetViewController: UIViewController
    private let emptyBottomSheetViewController: UIViewController
    
    private weak var currentLocationDirectionView: UIView?
    private var categoryItems: [CategoryItem] {
        viewModel.output.categoryItems
    }

    private var companionView: CompanionView {
        guard let view = view as? CompanionView else {
            fatalError("CompanionViewController view is not CompanionView")
        }
        return view
    }

    // MARK: - Initializer

    init(
        viewModel: CompanionViewModel,
        nearbyBottomSheetViewController: UIViewController,
        specificBottomSheetViewController: UIViewController,
        emptyBottomSheetViewController: UIViewController
    ) {
        self.nearbyBottomSheetViewController = nearbyBottomSheetViewController
        self.specificBottomSheetViewController = specificBottomSheetViewController
        self.emptyBottomSheetViewController = emptyBottomSheetViewController
        super.init(viewModel: viewModel)
    }

    // MARK: - Life Cycles

    override func loadView() {
        view = CompanionView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLocationManager()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingHeading()
    }

    // MARK: - Custom Methods

    override func setUI() {
        setBottomSheet()
    }

    override func setAddTarget() {
        companionView.currentLocationButton.addTarget(self, action: #selector(currentLocationButtonDidTap), for: .touchUpInside)
        companionView.recruitCompanionButton.addTarget(self, action: #selector(recruitCompanionButtonDidTap), for: .touchUpInside)
    }

    override func setDelegate() {
        companionView.categoryCollectionView.dataSource = self
        companionView.categoryCollectionView.delegate = self
    }

    // MARK: - Methods

    private func setBottomSheet() {
        setBottomSheetLayout()
        bindBottomSheet()
        initializeBottomSheetState()
    }

    private func setBottomSheetLayout() {
        addChild(bottomSheetViewController)
        view.insertSubview(bottomSheetViewController.view, aboveSubview: companionView.mapContainerView)

        bottomSheetViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        bottomSheetViewController.didMove(toParent: self)
    }

    private func bindBottomSheet() {
        bottomSheetViewController.onStateChange = { [weak self] height, state in
            guard let self = self else { return }
            self.updateBottomSheetLayer(for: state)
            self.companionView.updateMapControls(bottomInset: height + 12, state: state)
        }
    }

    private func initializeBottomSheetState() {
        bottomSheetViewController.setContentViewController(nearbyBottomSheetViewController)
        bottomSheetViewController.setState(content: .nearbyCompanionList, animated: false)
    }

    private func showNearbyBottomSheet(animated: Bool = true) {
        bottomSheetViewController.setContentViewController(nearbyBottomSheetViewController)
        bottomSheetViewController.setState(content: .nearbyCompanionList, animated: animated)
    }

    private func showEmptyBottomSheet(animated: Bool = true) {
        bottomSheetViewController.setContentViewController(emptyBottomSheetViewController)
        bottomSheetViewController.setState(content: .nearbyCompanionEmpty, animated: animated)
    }

    private func showSpecificBottomSheet(animated: Bool = true) {
        bottomSheetViewController.setContentViewController(specificBottomSheetViewController)
        bottomSheetViewController.setState(content: .specificRestaurantCompanionList, animated: animated)
    }

    private func updateBottomSheetLayer(for state: BottomSheetState) {
        if state.level == .expanded {
            view.bringSubviewToFront(bottomSheetViewController.view)
            view.bringSubviewToFront(companionView.recruitCompanionButton)
            return
        }

        view.insertSubview(bottomSheetViewController.view, aboveSubview: companionView.mapContainerView)
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
        companionView.mapView.animate(to: camera)
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
        marker.map = companionView.mapView
        marker.tracksViewChanges = true
        currentLocationMarker = marker
        stopTrackingViewChanges(for: marker)
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

        if let currentLocationMarker {
            currentLocationMarker.tracksViewChanges = true
            currentLocationDirectionView?.transform = CGAffineTransform(rotationAngle: headingRadian)
            stopTrackingViewChanges(for: currentLocationMarker)
        }
    }

    private func stopTrackingViewChanges(for marker: GMSMarker) {
        DispatchQueue.main.async {
            marker.tracksViewChanges = false
        }
    }

    // MARK: - Actions

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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = categoryItems[indexPath.item]

        if item.isRestaurant {
            showNearbyBottomSheet()
        } else {
            showEmptyBottomSheet()
        }
    }

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
