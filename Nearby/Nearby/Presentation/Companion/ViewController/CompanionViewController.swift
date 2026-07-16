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

    var onAlarmButtonDidTap: (() -> Void)?
    
    // MARK: - Properties

    private var isSpecificBottomSheetPresented = false
    private var isBottomSheetInitialized = false
    private var currentBottomSheetState = BottomSheetState(content: .nearbyCompanionList)
    private var selectedCategoryIndex: Int? = 0
    private var categoryItems: [CategoryItem] { viewModel.output.categoryItems }

    // MARK: - UI Components

    private let bottomSheetViewController = NearbyBottomSheetViewController()
    private let nearbySheetViewController: UIViewController
    private let specificSheetViewController: UIViewController
    private let emptySheetViewController: UIViewController
    private lazy var mapController = CompanionMapController(mapView: companionView.mapView, configuration: viewModel.output.mapConfiguration)
    private var bottomSheetHostView: UIView { view }
    private var bottomSheetParentViewController: UIViewController { self }
    private var companionView = CompanionView()

    // MARK: - Initializer

    init(
        viewModel: CompanionViewModel,
        nearbySheetViewController: UIViewController,
        specificSheetViewController: UIViewController,
        emptySheetViewController: UIViewController
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

        mapController.onCompanionMarkerTap = { [weak self] placeId in
            self?.showSpecificBottomSheet(for: placeId)
        }

        mapController.onLocationUpdate = { [weak self] coordinate in
            guard let nearbySheet = self?.nearbySheetViewController as? NearCompanionSheetViewController else { return }
            nearbySheet.updateLocation(coordinate)
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
        setTabBarHidden(isSpecificBottomSheetPresented)
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
                (self?.nearbySheetViewController as? NearCompanionSheetViewController)?.updateNickname(nickname)
                (self?.specificSheetViewController as? SpecificCompanionSheetViewController)?.updateNickname(nickname)
            }
            .store(in: &cancellables)
    }

    // MARK: - Methods

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

        bottomSheetViewController.setTopOverlayViews(
            centerView: companionView.companionCountChip,
            trailingView: companionView.currentLocationButton
        )

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

        if let nearbySheetViewController = nearbySheetViewController as? NearCompanionSheetViewController {
            nearbySheetViewController.onCompanionSelected = { [weak self] item in
                self?.showCompanionDetail(for: item)
            }
            nearbySheetViewController.onSummaryTextChanged = { [weak self] summaryText in
                self?.companionView.companionCountChip.updateTitle(summaryText)
            }
            nearbySheetViewController.onMapMarkersChanged = { [weak self] markers in
                self?.mapController.updateCompanionMarkers(markers)
            }
            nearbySheetViewController.onTitleMultilineChanged = { [weak self] isMultiline in
                self?.updateBottomSheetHeight(
                    for: .nearbyCompanionList,
                    isTitleMultiline: isMultiline
                )
            }
        }

        if let specificSheetViewController = specificSheetViewController as? SpecificCompanionSheetViewController {
            specificSheetViewController.onClose = { [weak self] in
                self?.showNearbyBottomSheet()
            }
            specificSheetViewController.onCompanionSelected = { [weak self] item in
                self?.showCompanionDetail(for: item)
            }
            specificSheetViewController.onTitleMultilineChanged = { [weak self] isMultiline in
                self?.updateBottomSheetHeight(
                    for: .specificRestaurantCompanionList,
                    isTitleMultiline: isMultiline
                )
            }
        }
    }

    private func updateBottomSheetHeight(for content: BottomSheetContent, isTitleMultiline: Bool) {
        let adjustment = isTitleMultiline ? NearbyBottomSheetValue.nearCompanionTitleHeight : 0
        DispatchQueue.main.async { [weak self] in
            self?.bottomSheetViewController.setHeightAdjustment(adjustment, for: content)
        }
    }

    private func initializeBottomSheetState() {
        bottomSheetViewController.setState(content: .nearbyCompanionList, animated: false)
        bottomSheetViewController.setContentViewController(nearbySheetViewController)
    }

    private func showNearbyBottomSheet(animated: Bool = true) {
        isSpecificBottomSheetPresented = false
        companionView.setCategoryChipsHidden(false)
        setTabBarHidden(false, animated: animated)
        bottomSheetViewController.setState(content: .nearbyCompanionList, animated: animated)
        bottomSheetViewController.setContentViewController(nearbySheetViewController)
    }

    private func showEmptyBottomSheet(animated: Bool = true) {
        isSpecificBottomSheetPresented = false
        companionView.setCategoryChipsHidden(false)
        setTabBarHidden(false, animated: animated)
        bottomSheetViewController.setState(content: .nearbyCompanionEmpty, animated: animated)
        bottomSheetViewController.setContentViewController(emptySheetViewController)
        (emptySheetViewController as? EmptyCompanionSheetViewController)?.restartAnimation()
        bottomSheetViewController.setState(content: .nearbyCompanionEmpty, animated: animated)
    }

    private func showSpecificBottomSheet(for placeId: Int, animated: Bool = true) {
        guard
            let nearbySheetViewController = nearbySheetViewController as? NearCompanionSheetViewController,
            let specificSheetViewController = specificSheetViewController as? SpecificCompanionSheetViewController
        else { return }

        specificSheetViewController.updateCompanions(
            nearbySheetViewController.specificCompanions(for: placeId)
        )
        isSpecificBottomSheetPresented = true
        companionView.setCategoryChipsHidden(true)
        setTabBarHidden(true, animated: animated)
        bottomSheetViewController.setState(content: .specificRestaurantCompanionList, animated: animated)
        bottomSheetViewController.setContentViewController(specificSheetViewController)
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

        let isSelected = selectedCategoryIndex == indexPath.item
        cell.configure(style: isSelected ? .companionCategorySelected : .companionCategoryUnselected,
                       title: item.title, icon: item.icon, iconColor: item.iconColor)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CompanionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = categoryItems[indexPath.item]
        let previousSelectedIndex = selectedCategoryIndex
        let isDeselecting = previousSelectedIndex == indexPath.item

        selectedCategoryIndex = isDeselecting ? nil : indexPath.item
        let changedIndexPaths = Set([previousSelectedIndex, selectedCategoryIndex].compactMap {
            $0.map { IndexPath(item: $0, section: 0) }
        })
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: Array(changedIndexPaths))
        }

        let nearbySheet = nearbySheetViewController as? NearCompanionSheetViewController
        if isDeselecting || item.isRestaurant {
            nearbySheet?.updatePlaceCategory("RESTAURANT")
            showNearbyBottomSheet()
        } else {
            showEmptyBottomSheet()
        }
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
