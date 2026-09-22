//
//  CompanionViewController.swift
//  Nearby
//
//  Created by soomin on 7/6/26.
//

import UIKit

import Combine
import SnapKit

final class CompanionViewController: BaseViewController<CompanionViewModel> {
    
    // MARK: - Properties
    
    var onAlarmButtonDidTap: (() -> Void)?
    private var isBottomSheetInitialized = false
    private var renderedViewState: CompanionViewModel.ViewState?
    private var categoryItems: [CategoryItem] { viewModel.output.categoryItems }
    
    // MARK: - UI Components
    
    private let bottomSheetController: CompanionBottomSheetController
    private lazy var mapController = CompanionMapController(mapView: companionView.mapView, configuration: viewModel.output.mapConfiguration)
    private var bottomSheetHostView: UIView { view }
    private var companionView = CompanionView()
    
    // MARK: - Initializer
    
    init(viewModel: CompanionViewModel, bottomSheetController: CompanionBottomSheetController) {
        self.bottomSheetController = bottomSheetController
        super.init(viewModel: viewModel)
    }
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = companionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapController.onMarkerTap = { [weak self] placeId in
            self?.viewModel.action(.markerDidSelect(placeId))
        }
        
        mapController.onLocationUpdate = { [weak self] coordinate in
            self?.bottomSheetController.updateLocation(coordinate)
        }
        
        viewModel.action(.viewDidLoad)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard !isBottomSheetInitialized,
              view.bounds.width > 0,
              view.bounds.height > 0 else { return }
        
        isBottomSheetInitialized = true
        renderBottomSheet(viewModel.output.viewState.value.bottomSheet, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setRecruitCompanionButtonLayout()
        let bottomSheet = viewModel.output.viewState.value.bottomSheet
        setTabBarHidden(bottomSheet.content == .specificRestaurantCompanionList)
        mapController.start()
        setBottomSheetHidden(false)
        companionView.updateMapControls(for: bottomSheet)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapController.stop()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let bottomSheet = viewModel.output.viewState.value.bottomSheet
        companionView.updateMapControls(for: bottomSheet)
        updateBottomSheetLayer(for: bottomSheet)
    }
    
    // MARK: - Custom Methods
    
    override func setUI() {
        bottomSheetController.attach(to: self, in: bottomSheetHostView, centerOverlayView: companionView.companionCountChip, trailingOverlayView: companionView.currentLocationButton)
        bindBottomSheet()
        setRecruitCompanionButtonLayout()
    }
    
    override func setAddTarget() {
        companionView.onAlarmButtonDidTap = { [weak self] in
            self?.onAlarmButtonDidTap?()
        }
        companionView.currentLocationButton.addTarget(self, action: #selector(currentLocationButtonDidTap), for: .touchUpInside)
        companionView.recruitCompanionButton.addTarget(self, action: #selector(recruitCompanionButtonDidTap), for: .touchUpInside)
    }
    
    override func setDelegate() {
        companionView.categoryCollectionView.dataSource = self
        companionView.categoryCollectionView.delegate = self
    }
    
    override func bindState() {
        viewModel.output.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
        
        viewModel.output.event
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .moveToCurrentLocation:
                    self?.mapController.moveToCurrentLocation()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    
    private func setRecruitCompanionButtonLayout() {
        let button = companionView.recruitCompanionButton
        bottomSheetHostView.addSubview(button)
        let bottomInset = (tabBarController?.tabBar.bounds.height ?? 0) + 11
        
        button.snp.remakeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(bottomInset)
            $0.width.equalTo(142)
            $0.height.equalTo(44)
        }
    }
    
    private func bindBottomSheet() {
        bottomSheetController.onStateChange = { [weak self] state in
            guard let self else { return }
            
            viewModel.action(.bottomSheetDidChange(state))
            updateBottomSheetLayer(for: state)
            companionView.updateMapControls(for: state)
        }
        
        bottomSheetController.onCompanionSelected = { [weak self] detailState in
            self?.viewModel.action(.companionDidSelect(detailState))
        }
        bottomSheetController.onSummaryTextChanged = { [weak self] summaryText in
            self?.companionView.companionCountChip.updateTitle(summaryText)
        }
        bottomSheetController.onMapMarkersChanged = { [weak self] markers in
            guard let self else { return }
            let shouldShowMarkers = viewModel.output.viewState.value.category.shouldShowCompanionMarkers
            mapController.updateCompanionMarkers(shouldShowMarkers ? markers : [])
        }
        bottomSheetController.onSpecificSheetClose = { [weak self] in
            self?.viewModel.action(.specificSheetDidClose)
        }
    }
    
    private func render(_ state: CompanionViewModel.ViewState) {
        let previousState = renderedViewState
        
        if previousState?.nickname != state.nickname, let nickname = state.nickname {
            bottomSheetController.updateNickname(nickname)
        }
        
        if previousState?.category != state.category {
            applyCategoryState(state.category)
        }
        
        if previousState?.selectedPlaceId != state.selectedPlaceId, let placeId = state.selectedPlaceId {
            bottomSheetController.updateSpecificCompanions(for: placeId)
        }
        
        if previousState?.bottomSheet != state.bottomSheet, isBottomSheetInitialized {
            renderBottomSheet(state.bottomSheet)
        }
        
        renderedViewState = state
    }
    
    private func renderBottomSheet(_ state: BottomSheetState, animated: Bool = true) {
        let isSpecific = state.content == .specificRestaurantCompanionList
        companionView.setCategoryChipsHidden(isSpecific)
        setTabBarHidden(isSpecific, animated: animated)
        bottomSheetController.render(state, animated: animated)
    }
    
    private func applyCategoryState(_ state: CompanionViewModel.CategoryState) {
        let changedIndexPaths = Set([state.previousIndex, state.selectedIndex].compactMap {
            $0.map { IndexPath(item: $0, section: 0) }
        })
        UIView.performWithoutAnimation {
            companionView.categoryCollectionView.reloadItems(at: Array(changedIndexPaths))
        }
        
        switch state.content {
        case .companions(let category):
            bottomSheetController.updatePlaceCategory(category)
        case .empty:
            mapController.updateCompanionMarkers([])
        }
    }
    
    private func setBottomSheetHidden(_ isHidden: Bool) { bottomSheetController.setHidden(isHidden) }
    
    private func setTabBarHidden(_ isHidden: Bool, animated: Bool = false) {
        guard let tabBar = tabBarController?.tabBar else { return }
        
        tabBar.isHidden = false
        tabBar.isUserInteractionEnabled = !isHidden
        
        if !isHidden {
            tabBar.superview?.bringSubviewToFront(tabBar)
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
        bottomSheetController.bringToFront(in: bottomSheetHostView)
        
        if state.content == .nearbyCompanionList,
           state.level == .standard || state.level == .expanded {
            bottomSheetHostView.bringSubviewToFront(companionView.recruitCompanionButton)
        }
        
        if state.content != .specificRestaurantCompanionList,
           let tabBar = tabBarController?.tabBar {
            tabBar.superview?.bringSubviewToFront(tabBar)
        }
    }
    
    // MARK: - Public Method
    
    func resetToInitialState() {
        setBottomSheetHidden(false)
        viewModel.action(.reset)
    }
    
    // MARK: - Actions
    
    @objc
    private func currentLocationButtonDidTap() {
        viewModel.action(.currentLocationButtonDidTap)
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(NearbyChipCollectionViewCell.self, for: indexPath)
        let item = categoryItems[indexPath.item]
        
        let isSelected = viewModel.output.viewState.value.category.selectedIndex == indexPath.item
        cell.configure(style: isSelected ? .companionCategorySelected : .companionCategoryUnselected,
                       title: item.title, icon: item.icon, iconColor: item.iconColor)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CompanionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.action(.categoryDidSelect(indexPath.item))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = categoryItems[indexPath.item]
        let titleWidth = (item.title as NSString).size(withAttributes: [.font: NearbyChipStyle.category.font]).width
        let iconWidth: CGFloat = 24
        let horizontalInset: CGFloat = 24
        
        return CGSize(width: ceil(titleWidth + iconWidth + horizontalInset), height: NearbyChipStyle.category.height)
    }
}

// MARK: - MainTabSwitchPreparing

extension CompanionViewController: MainTabSwitchPreparing {
    func prepareForTabSwitch() {
        bottomSheetController.setHidden(true)
        companionView.recruitCompanionButton.isHidden = true
    }
}
