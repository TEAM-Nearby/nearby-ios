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
    private var currentBottomSheetState = BottomSheetState(content: .nearbyCompanionList)
    private var categoryItems: [CategoryItem] { viewModel.output.categoryItems }
    
    // MARK: - UI Components
    
    private let bottomSheetViewController = NearbyBottomSheetViewController()
    private let nearbySheetViewController: NearCompanionSheetViewController
    private let specificSheetViewController: SpecificCompanionSheetViewController
    private let emptySheetViewController: EmptyCompanionSheetViewController
    private lazy var mapController = CompanionMapController(mapView: companionView.mapView, configuration: viewModel.output.mapConfiguration)
    private var bottomSheetHostView: UIView { view }
    private var bottomSheetParentViewController: UIViewController { self }
    private var companionView = CompanionView()
    
    // MARK: - Initializer
    
    init(
        viewModel: CompanionViewModel,
        nearbySheetViewController: NearCompanionSheetViewController,
        specificSheetViewController: SpecificCompanionSheetViewController,
        emptySheetViewController: EmptyCompanionSheetViewController
    ) {
        self.nearbySheetViewController = nearbySheetViewController
        self.specificSheetViewController = specificSheetViewController
        self.emptySheetViewController = emptySheetViewController
        super.init(viewModel: viewModel)
    }
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = companionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapController.onMarkerTap = { [weak self] placeId in
            self?.showSpecificBottomSheet(for: placeId)
        }
        
        mapController.onLocationUpdate = { [weak self] coordinate in
            self?.nearbySheetViewController.updateLocation(coordinate)
        }
        
        viewModel.action(.viewDidLoad)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard !isBottomSheetInitialized,
              view.bounds.width > 0,
              view.bounds.height > 0 else { return }
        
        isBottomSheetInitialized = true
        initializeBottomSheetState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setRecruitCompanionButtonLayout()
        setTabBarHidden(currentBottomSheetState.content == .specificRestaurantCompanionList)
        mapController.start()
        setBottomSheetHidden(false)
        companionView.updateMapControls(for: currentBottomSheetState)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapController.stop()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        companionView.updateMapControls(for: currentBottomSheetState)
        updateBottomSheetLayer(for: currentBottomSheetState)
    }
    
    // MARK: - Custom Methods
    
    override func setUI() {
        setBottomSheet()
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
        viewModel.output.nickname
            .receive(on: DispatchQueue.main)
            .sink { [weak self] nickname in
                self?.nearbySheetViewController.updateNickname(nickname)
                self?.specificSheetViewController.updateNickname(nickname)
            }
            .store(in: &cancellables)
        
        viewModel.output.categoryState
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.applyCategoryState(state)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    
    private func setBottomSheet() {
        setBottomSheetLayout()
        bindBottomSheet()
    }
    
    private func setBottomSheetLayout() {
        let parentViewController = bottomSheetParentViewController
        
        parentViewController.addChild(bottomSheetViewController)
        bottomSheetHostView.addSubview(bottomSheetViewController.view)
        
        bottomSheetViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomSheetViewController.setTopOverlayViews(centerView: companionView.companionCountChip, trailingView: companionView.currentLocationButton)
        
        setRecruitCompanionButtonLayout()
        
        bottomSheetViewController.didMove(toParent: parentViewController)
    }
    
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
        bottomSheetViewController.onStateChange = { [weak self] _, state in
            guard let self else { return }
            
            currentBottomSheetState = state
            updateBottomSheetLayer(for: state)
            companionView.updateMapControls(for: state)
        }
        
        nearbySheetViewController.onCompanionSelected = { [weak self] item in
            self?.showCompanionDetail(for: item)
        }
        nearbySheetViewController.onSummaryTextChanged = { [weak self] summaryText in
            self?.companionView.companionCountChip.updateTitle(summaryText)
        }
        nearbySheetViewController.onMapMarkersChanged = { [weak self] markers in
            guard let self else { return }
            let shouldShowMarkers = viewModel.output.categoryState.value.shouldShowCompanionMarkers
            mapController.updateCompanionMarkers(shouldShowMarkers ? markers : [])
        }
        nearbySheetViewController.onTitleMultilineChanged = { [weak self] isMultiline in
            self?.updateBottomSheetHeight(for: .nearbyCompanionList, isTitleMultiline: isMultiline)
        }
        
        specificSheetViewController.onClose = { [weak self] in
            self?.showNearbyBottomSheet()
        }
        specificSheetViewController.onCompanionSelected = { [weak self] item in
            self?.showCompanionDetail(for: item)
        }
        specificSheetViewController.onTitleMultilineChanged = { [weak self] isMultiline in
            self?.updateBottomSheetHeight(for: .specificRestaurantCompanionList, isTitleMultiline: isMultiline)
        }
    }
    
    private func updateBottomSheetHeight(for content: BottomSheetContent, isTitleMultiline: Bool) {
        let adjustment = isTitleMultiline ? NearbyBottomSheetValue.nearCompanionTitleHeight : 0
        DispatchQueue.main.async { [weak self] in
            self?.bottomSheetViewController.setHeightAdjustment(adjustment, for: content)
        }
    }
    
    private func initializeBottomSheetState() {
        showBottomSheet(.nearbyCompanionList, animated: false)
    }
    
    private func showNearbyBottomSheet(animated: Bool = true) {
        showBottomSheet(.nearbyCompanionList, animated: animated)
    }
    
    private func showEmptyBottomSheet(animated: Bool = true) {
        showBottomSheet(.nearbyCompanionEmpty, animated: animated)
    }
    
    private func showSpecificBottomSheet(for placeId: Int, animated: Bool = true) {
        specificSheetViewController.updateCompanions(nearbySheetViewController.specificCompanions(for: placeId))
        showBottomSheet(.specificRestaurantCompanionList, animated: animated)
    }
    
    private func showBottomSheet(_ content: BottomSheetContent, level: BottomSheetLevel? = nil, animated: Bool) {
        let isSpecific = content == .specificRestaurantCompanionList
        currentBottomSheetState = BottomSheetState(content: content, level: level)
        companionView.setCategoryChipsHidden(isSpecific)
        setTabBarHidden(isSpecific, animated: animated)
        bottomSheetViewController.setState(content: content, level: level, animated: animated)
        
        switch content {
        case .nearbyCompanionList:
            bottomSheetViewController.setContentViewController(nearbySheetViewController)
        case .nearbyCompanionEmpty:
            bottomSheetViewController.setContentViewController(emptySheetViewController)
            emptySheetViewController.restartAnimation()
        case .specificRestaurantCompanionList:
            bottomSheetViewController.setContentViewController(specificSheetViewController)
        default:
            break
        }
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
            nearbySheetViewController.updatePlaceCategory(category)
            showNearbyBottomSheet()
        case .empty:
            mapController.updateCompanionMarkers([])
            showEmptyBottomSheet()
        }
    }
    
    private func showCompanionDetail(for item: NearCompanionCellItem) {
        viewModel.action(.companionDidSelect(item.detailState))
    }
    
    private func showCompanionDetail(for item: SpecificCompanionCellItem) {
        viewModel.action(.companionDidSelect(item.detailState))
    }
    
    private func setBottomSheetHidden(_ isHidden: Bool) { bottomSheetViewController.view.isHidden = isHidden }
    
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
        bottomSheetHostView.bringSubviewToFront(bottomSheetViewController.view)
        
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
        showBottomSheet(.nearbyCompanionList, level: .compact, animated: false)
    }
    
    // MARK: - Actions
    
    @objc
    private func currentLocationButtonDidTap() {
        mapController.moveToCurrentLocation()
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
        
        let isSelected = viewModel.output.categoryState.value.selectedIndex == indexPath.item
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
        bottomSheetViewController.view.isHidden = true
        companionView.recruitCompanionButton.isHidden = true
    }
}
