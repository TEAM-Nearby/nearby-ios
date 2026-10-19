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
    private var isScreenVisible = false
    private var isBottomSheetInitialized = false
    private var restaurantSummaryText = "내 주변 0개의 동행이 있어요"
    private var renderedViewState: CompanionViewModel.ViewState?
    private var categoryItems: [CategoryItem] { viewModel.output.categoryItems }

    // MARK: - UI Components

    private let listLoadingView = LoadingView()

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
            self?.viewModel.action(.locationDidUpdate(coordinate))
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
        isScreenVisible = true
        refreshCompanions()
        setRecruitCompanionButtonLayout()
        viewModel.action(.refreshNotifications)
        let bottomSheet = viewModel.output.viewState.value.bottomSheet
        setTabBarHidden(bottomSheet.content == .specificRestaurantCompanionList)
        mapController.start()
        setBottomSheetHidden(false)
        updateMapControls()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isScreenVisible = false
        bottomSheetController.stopRefreshing()
        listLoadingView.isHidden = true
        mapController.stop()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let bottomSheet = viewModel.output.viewState.value.bottomSheet
        updateMapControls()
        updateBottomSheetLayer(for: bottomSheet)
    }

    // MARK: - Custom Methods

    override func setUI() {
        bottomSheetController.attach(to: self, in: bottomSheetHostView, centerOverlayView: companionView.companionCountChip, trailingOverlayView: companionView.currentLocationButton)
        bindBottomSheet()
        setRecruitCompanionButtonLayout()
        listLoadingView.isHidden = true
        listLoadingView.configure(message: "잠시만 기다려주세요")
        view.addSubview(listLoadingView)
        listLoadingView.snp.makeConstraints { $0.edges.equalToSuperview() }
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
        bottomSheetController.listState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                let isRelevant = isScreenVisible && viewModel.output.viewState.value.category.content.shouldShowCompanions
                if case .loading = state {
                    listLoadingView.isHidden = !isRelevant
                    if isRelevant { view.bringSubviewToFront(listLoadingView) }
                } else {
                    listLoadingView.isHidden = true
                }
                if case .failed(let error) = state, isRelevant {
                    showListError(error)
                }
                if case .loaded = state, let placeId = viewModel.output.viewState.value.selectedPlaceId {
                    bottomSheetController.updateSpecificCompanions(for: placeId)
                }
            }
            .store(in: &cancellables)

        viewModel.output.hasUnreadNotifications
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hasUnread in
                self?.companionView.updateAlarm(hasUnread: hasUnread)
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .merge(with: NotificationCenter.default.publisher(for: .companionNotificationDidChange))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.action(.refreshNotifications)
            }
            .store(in: &cancellables)

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

    // MARK: - Methods

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
            updateMapControls()
            updateBottomSheetLayer(for: state)
        }

        bottomSheetController.onCompanionSelected = { [weak self] detailState in
            self?.viewModel.action(.companionDidSelect(detailState))
        }
        bottomSheetController.onSummaryTextChanged = { [weak self] summaryText in
            guard let self else { return }
            restaurantSummaryText = summaryText
            updateCompanionSummary()
        }
        bottomSheetController.onMapMarkersChanged = { [weak self] markers in
            guard let self else { return }
            let shouldShowMarkers = viewModel.output.viewState.value.category.shouldShowCompanionMarkers
            mapController.updateCompanionMarkers(shouldShowMarkers ? markers : [])
        }
        bottomSheetController.onCompanionAvailabilityChanged = { [weak self] hasCompanions in
            self?.viewModel.action(.companionAvailabilityDidChange(hasCompanions))
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

        updateMapControls(for: state)
        updateBottomSheetLayer(for: state.bottomSheet)
        updateCompanionSummary()
        renderedViewState = state
    }

    private func renderBottomSheet(_ state: BottomSheetState, animated: Bool = true) {
        let isSpecific = state.content == .specificRestaurantCompanionList
        companionView.setCategoryChipsHidden(isSpecific)
        setTabBarHidden(isSpecific, animated: animated)
        bottomSheetController.render(state, animated: animated)
        updateMapControls()
        updateBottomSheetLayer(for: state)
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
            bottomSheetController.stopRefreshing()
            listLoadingView.isHidden = true
            mapController.updateCompanionMarkers([])
        }
    }

    private func updateMapControls(for state: CompanionViewModel.ViewState? = nil) {
        let state = state ?? viewModel.output.viewState.value
        companionView.updateMapControls(for: state.bottomSheet, showsRestaurantCompanions: state.category.content.shouldShowCompanions)
    }

    private func updateCompanionSummary() {
        let showsRestaurantCompanions = viewModel.output.viewState.value.category.content.shouldShowCompanions
        companionView.companionCountChip.updateTitle(showsRestaurantCompanions ? restaurantSummaryText : "내 주변 0개의 동행이 있어요")
    }

    private func showListError(_ error: Error) {
        guard presentedViewController == nil else { return }
        let isConnectionError = (error as? NetworkError).map { $0 == .networkFail || $0 == .timeout } ?? (error is URLError)
        let alert = UIAlertController(
            title: isConnectionError ? "연결이 원활하지 않아요" : "동행 목록을 불러오지 못했어요",
            message: isConnectionError ? "인터넷 연결을 확인하고 다시 시도해주세요." : "잠시 후 다시 시도해주세요.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "다시 시도", style: .default) { [weak self] _ in
            self?.refreshCompanions()
        })
        present(alert, animated: true)
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

        if !companionView.recruitCompanionButton.isHidden {
            bottomSheetHostView.bringSubviewToFront(companionView.recruitCompanionButton)
        }

        if state.content != .specificRestaurantCompanionList,
           let tabBar = tabBarController?.tabBar {
            tabBar.superview?.bringSubviewToFront(tabBar)
        }
        if !listLoadingView.isHidden {
            view.bringSubviewToFront(listLoadingView)
        }
    }

    func refreshCompanions() {
        guard isScreenVisible, viewModel.output.viewState.value.category.content.shouldShowCompanions else { return }
        bottomSheetController.refreshCompanions()
    }

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
