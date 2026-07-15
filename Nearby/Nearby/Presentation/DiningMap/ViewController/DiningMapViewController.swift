//
//  DiningMapViewController.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import UIKit

import Combine
import SnapKit

final class DiningMapViewController: BaseViewController<DiningMapViewModel> {

    var onAlarmButtonDidTap: (() -> Void)?
    
    // MARK: - Properties
    
    private let diningMapView = DiningMapView()
    private let bottomSheetViewController = NearbyBottomSheetViewController()
    private let nearDiningSheetViewController: NearDiningSheetViewController
    private let saveDiningSheetViewController: SaveDiningSheetViewController
    private let diningInfoSheetViewController: DiningInfoSheetViewController
    private var isSaveDiningSheetPresented = false
    private var isBottomSheetInitialized = false
    private lazy var mapController = CompanionMapController(mapView: diningMapView.mapView, configuration: viewModel.output.mapConfiguration)
    private var bottomSheetHostView: UIView { tabBarController?.view ?? view }
    private var bottomSheetParentViewController: UIViewController { tabBarController ?? self }

    // MARK: - Initializer
    
    init(
        viewModel: DiningMapViewModel,
        nearDiningSheetViewController: NearDiningSheetViewController,
        saveDiningSheetViewController: SaveDiningSheetViewController,
        diningInfoSheetViewController: DiningInfoSheetViewController
    ) {
        self.nearDiningSheetViewController = nearDiningSheetViewController
        self.saveDiningSheetViewController = saveDiningSheetViewController
        self.diningInfoSheetViewController = diningInfoSheetViewController
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycles
    
    override func loadView() {
        view = diningMapView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard !isBottomSheetInitialized,
              view.bounds.width > 0,
              view.bounds.height > 0 else { return }

        isBottomSheetInitialized = true
        bottomSheetViewController.setState(content: .diningMapList, level: .standard, animated: false)
        bottomSheetViewController.setContentViewController(nearDiningSheetViewController)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        mapController.start()
        bottomSheetViewController.view.isHidden = false
        setTabBarHidden(isSaveDiningSheetPresented)
        updateBottomSheetLayer(for: isSaveDiningSheetPresented ? BottomSheetState(content: .savedRestaurantList) : BottomSheetState(content: .diningMapList))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideBottomSheetAfterTransition()
        mapController.stop()
    }

    // MARK: - Custom Methods
    
    override func setUI() {
        let parentViewController = bottomSheetParentViewController
        parentViewController.addChild(bottomSheetViewController)
        bottomSheetHostView.addSubview(bottomSheetViewController.view)
        
        bottomSheetViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        bottomSheetViewController.didMove(toParent: parentViewController)

        bottomSheetViewController.onStateChange = { [weak self] _, state in
            let shouldHideMapButtons = state.level == .expanded && state.content != .diningInfo
            self?.diningMapView.currentLocationButton.isHidden = shouldHideMapButtons
            self?.diningMapView.bookmarkButton.isHidden = shouldHideMapButtons
            self?.updateBottomSheetLayer(for: state)
        }
        bottomSheetViewController.setTrailingOverlayViews(lowerView: diningMapView.currentLocationButton, upperView: diningMapView.bookmarkButton)

        nearDiningSheetViewController.onRestaurantSelected = { [weak self] item in
            self?.showDiningInfoSheet(for: item)
        }
        
        nearDiningSheetViewController.onMapMarkersChanged = { [weak self] markers in
            self?.mapController.updateDiningMarkers(markers)
        }
        
        mapController.onCompanionMarkerTap = { [weak self] placeId in
            guard let item = self?.nearDiningSheetViewController.restaurant(placeId: placeId) else { return }
            self?.showDiningInfoSheet(for: item)
        }
        
        saveDiningSheetViewController.onRestaurantSelected = { [weak self] item in
            self?.showDiningInfoSheet(for: item)
        }

        saveDiningSheetViewController.onFavoriteUpdate = { [weak self] placeId, isFavorite in
            self?.nearDiningSheetViewController.updateFavorite(
                placeId: placeId,
                isFavorite: isFavorite
            )
        }
        
        diningInfoSheetViewController.onClose = { [weak self] in
            guard let self else { return }
            if isSaveDiningSheetPresented {
                showSaveDiningSheet()
            } else {
                showNearDiningSheet()
            }
        }

        diningInfoSheetViewController.onFavoriteUpdate = { [weak self] placeId, isFavorite in
            self?.nearDiningSheetViewController.updateFavorite(
                placeId: placeId,
                isFavorite: isFavorite
            )
            self?.saveDiningSheetViewController.updateFavorite(
                placeId: placeId,
                isFavorite: isFavorite
            )
        }

        mapController.onLocationUpdate = { [weak self] coordinate in
            self?.nearDiningSheetViewController.updateLocation(coordinate)
            self?.saveDiningSheetViewController.updateLocation(coordinate)
        }
    }

    override func setAddTarget() {
        diningMapView.onAlarmButtonDidTap = { [weak self] in
            self?.onAlarmButtonDidTap?()
        }
        diningMapView.currentLocationButton.addTarget(self, action: #selector(currentLocationButtonDidTap), for: .touchUpInside)
        diningMapView.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonDidTap), for: .touchUpInside)
    }

    override func bindState() {
        viewModel.output.isBookmarkSelected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSelected in
                self?.diningMapView.bookmarkButton.isSelected = isSelected
            }
            .store(in: &cancellables)
    }

    // MARK: - Methods
    
    private func showSaveDiningSheet(animated: Bool = true) {
        isSaveDiningSheetPresented = true
        saveDiningSheetViewController.refresh()
        setTabBarHidden(true, animated: animated)
        bottomSheetViewController.setState(content: .savedRestaurantList, animated: animated)
        bottomSheetViewController.setContentViewController(saveDiningSheetViewController)
    }

    private func showNearDiningSheet(animated: Bool = true) {
        isSaveDiningSheetPresented = false
        setTabBarHidden(false, animated: animated)
        bottomSheetViewController.setState(content: .diningMapList, animated: animated)
        bottomSheetViewController.setContentViewController(nearDiningSheetViewController)
    }

    private func showDiningInfoSheet(for item: NearDiningCellItem, animated: Bool = true) {
        setTabBarHidden(true, animated: animated)
        diningInfoSheetViewController.configure(with: item)
        bottomSheetViewController.setState(content: .diningInfo, animated: animated)
        bottomSheetViewController.setContentViewController(diningInfoSheetViewController)
    }

    private func hideBottomSheetAfterTransition() {
        bottomSheetViewController.view.isHidden = true
        setTabBarHidden(false)

        transitionCoordinator?.animate(alongsideTransition: nil) { [weak self] context in
            guard context.isCancelled else { return }
            self?.bottomSheetViewController.view.isHidden = false
            self?.setTabBarHidden(self?.isSaveDiningSheetPresented == true)
        }
    }

    private func setTabBarHidden(_ isHidden: Bool, animated: Bool = false) {
        guard let tabBar = tabBarController?.tabBar else { return }

        tabBar.isHidden = false
        tabBar.isUserInteractionEnabled = !isHidden

        if !isHidden {
            bottomSheetHostView.bringSubviewToFront(tabBar)
        }

        let animations = {
            let hiddenTransform = CGAffineTransform(translationX: 0, y: tabBar.bounds.height + self.view.safeAreaInsets.bottom)
            tabBar.alpha = isHidden ? 0 : 1
            tabBar.transform = isHidden ? hiddenTransform : .identity
            self.tabBarController?.view.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }

        guard animated else {
            animations()
            return
        }

        UIView.animate(withDuration: 0.28, delay: 0, usingSpringWithDamping: 0.86, initialSpringVelocity: 0.4, options: [.beginFromCurrentState, .curveEaseOut], animations: animations)
    }

    private func updateBottomSheetLayer(for state: BottomSheetState) {
        bottomSheetHostView.bringSubviewToFront(bottomSheetViewController.view)

        if state.content != .savedRestaurantList,
           state.content != .diningInfo,
           let tabBar = tabBarController?.tabBar {
            bottomSheetHostView.bringSubviewToFront(tabBar)
        }
    }

    // MARK: - Actions
    
    @objc
    private func currentLocationButtonDidTap() {
        mapController.moveToCurrentLocation()
    }

    @objc
    private func bookmarkButtonDidTap() {
        viewModel.action(.bookmarkDidTap)
        if isSaveDiningSheetPresented {
            showNearDiningSheet()
        } else {
            showSaveDiningSheet()
        }
    }
}

// MARK: - MainTabSwitchPreparing

extension DiningMapViewController: MainTabSwitchPreparing {
    func prepareForTabSwitch() {
        bottomSheetViewController.view.isHidden = true
    }
}
