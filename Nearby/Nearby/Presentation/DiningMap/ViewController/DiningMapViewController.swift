//
//  DiningMapViewController.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import UIKit

final class DiningMapViewController: BaseViewController<DiningMapViewModel> {
    
    // MARK: - Properties
    
    var onAlarmButtonDidTap: (() -> Void)?
    private let diningMapView = DiningMapView()
    private let bottomSheetController: DiningMapBottomSheetController
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
        self.bottomSheetController = DiningMapBottomSheetController(
            nearDiningSheetViewController: nearDiningSheetViewController,
            saveDiningSheetViewController: saveDiningSheetViewController,
            diningInfoSheetViewController: diningInfoSheetViewController
        )
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = diningMapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard view.bounds.width > 0, view.bounds.height > 0 else { return }
        bottomSheetController.initializeIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        mapController.start()
        bottomSheetController.setHidden(false)
        updateScreenAppearance(for: bottomSheetController.screenState)
        updateBottomSheetLayer(for: BottomSheetState(content: bottomSheetController.screenState.bottomSheetContent))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideBottomSheetAfterTransition()
        mapController.stop()
    }
    
    // MARK: - Custom Methods
    
    override func setUI() {
        bindBottomSheetEvents()
        bottomSheetController.install(in: bottomSheetParentViewController, hostView: bottomSheetHostView,
                                      lowerOverlayView: diningMapView.currentLocationButton, upperOverlayView: diningMapView.bookmarkButton)
        
        mapController.onCompanionMarkerTap = { [weak self] placeId in
            self?.bottomSheetController.selectRestaurant(placeId: placeId)
        }
        
        mapController.onLocationUpdate = { [weak self] coordinate in
            self?.bottomSheetController.updateLocation(coordinate)
        }
    }
    
    override func setAddTarget() {
        diningMapView.onAlarmButtonDidTap = { [weak self] in
            self?.onAlarmButtonDidTap?()
        }
        diningMapView.currentLocationButton.addTarget(self, action: #selector(currentLocationButtonDidTap), for: .touchUpInside)
        diningMapView.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Methods
    
    private func bindBottomSheetEvents() {
        bottomSheetController.onEvent = { [weak self] event in
            guard let self else { return }
            switch event {
            case .screenStateChanged(let state):
                updateScreenAppearance(for: state, animated: true)
            case .bottomSheetStateChanged(let state):
                updateMapButtons(for: state)
                updateBottomSheetLayer(for: state)
            case .markersChanged(let markers):
                mapController.updateDiningMarkers(markers)
            }
        }
    }
    
    private func updateScreenAppearance(for state: DiningMapScreenState, animated: Bool = false) {
        diningMapView.bookmarkButton.isSelected = state.isBookmarkSelected
        setTabBarHidden(state.hidesTabBar, animated: animated)
    }
    
    private func updateMapButtons(for state: BottomSheetState) {
        let shouldHideMapButtons = state.level == .expanded && state.content != .diningInfo
        diningMapView.currentLocationButton.isHidden = shouldHideMapButtons
        diningMapView.bookmarkButton.isHidden = shouldHideMapButtons
    }
    
    private func hideBottomSheetAfterTransition() {
        bottomSheetController.setHidden(true)
        setTabBarHidden(false)
        
        transitionCoordinator?.animate(alongsideTransition: nil) { [weak self] context in
            guard context.isCancelled, let self else { return }
            bottomSheetController.setHidden(false)
            setTabBarHidden(bottomSheetController.screenState.hidesTabBar)
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
        
        UIView.animate(withDuration: 0.28, delay: 0, usingSpringWithDamping: 0.86, initialSpringVelocity: 0.4,
                       options: [.beginFromCurrentState, .curveEaseOut], animations: animations)
    }
    
    private func updateBottomSheetLayer(for state: BottomSheetState) {
        bottomSheetHostView.bringSubviewToFront(bottomSheetController.view)
        
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
        bottomSheetController.toggleList()
    }
}

// MARK: - MainTabSwitchPreparing

extension DiningMapViewController: MainTabSwitchPreparing {
    func prepareForTabSwitch() {
        bottomSheetController.setHidden(true)
    }
}
