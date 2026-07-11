//
//  CompanionViewController.swift
//  Nearby
//
//  Created by soomin on 7/6/26.
//

import UIKit

import SnapKit

final class CompanionViewController: BaseViewController<CompanionViewModel> {
    
    // MARK: - Properties

    private var isSpecificBottomSheetPresented = false
    private var categoryItems: [CategoryItem] { viewModel.output.categoryItems }

    // MARK: - UI Components

    private let bottomSheetViewController = NearbyBottomSheetViewController()
    private let nearbySheetViewController: UIViewController
    private let specificSheetViewController: UIViewController
    private let emptySheetViewController: UIViewController
    private lazy var mapController = CompanionMapController(mapView: companionView.mapView, configuration: viewModel.output.mapConfiguration)
    private var bottomSheetHostView: UIView { tabBarController?.view ?? view }
    private var bottomSheetParentViewController: UIViewController { tabBarController ?? self }
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

        mapController.onCompanionMarkerTap = { [weak self] in
            self?.showSpecificBottomSheet()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapController.start()
        setBottomSheetHidden(false)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideBottomSheetAfterTransition()
        mapController.stop()
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

        bottomSheetViewController.didMove(toParent: parentViewController)
    }

    private func bindBottomSheet() {
        bottomSheetViewController.onStateChange = { [weak self] _, state in
            guard let self else { return }

            updateBottomSheetLayer(for: state)
            companionView.updateMapControls(for: state)
        }

        if let nearbySheetViewController = nearbySheetViewController as? NearCompanionSheetViewController {
            nearbySheetViewController.onCompanionSelected = { [weak self] item in
                self?.showCompanionDetail(for: item)
            }
        }

        if let specificSheetViewController = specificSheetViewController as? SpecificCompanionSheetViewController {
            specificSheetViewController.onClose = { [weak self] in
                self?.showNearbyBottomSheet()
            }
            specificSheetViewController.onCompanionSelected = { [weak self] item in
                self?.showCompanionDetail(for: item)
            }
        }
    }

    private func initializeBottomSheetState() {
        bottomSheetViewController.setContentViewController(nearbySheetViewController)
        bottomSheetViewController.setState(content: .nearbyCompanionList, animated: false)
    }

    private func showNearbyBottomSheet(animated: Bool = true) {
        isSpecificBottomSheetPresented = false
        companionView.setCategoryChipsHidden(false)
        setTabBarHidden(false, animated: animated)
        bottomSheetViewController.setContentViewController(nearbySheetViewController)
        bottomSheetViewController.setState(content: .nearbyCompanionList, animated: animated)
    }

    private func showEmptyBottomSheet(animated: Bool = true) {
        isSpecificBottomSheetPresented = false
        companionView.setCategoryChipsHidden(false)
        setTabBarHidden(false, animated: animated)
        bottomSheetViewController.setContentViewController(emptySheetViewController)
        bottomSheetViewController.setState(content: .nearbyCompanionEmpty, animated: animated)
    }

    private func showSpecificBottomSheet(animated: Bool = true) {
        isSpecificBottomSheetPresented = true
        companionView.setCategoryChipsHidden(true)
        setTabBarHidden(true, animated: animated)
        bottomSheetViewController.setContentViewController(specificSheetViewController)
        bottomSheetViewController.setState(content: .specificRestaurantCompanionList, animated: animated)
    }

    private func showCompanionDetail(for item: NearCompanionCellItem) {
        viewModel.action(.companionDidSelect(item.detailState))
    }

    private func showCompanionDetail(for item: SpecificCompanionCellItem) {
        viewModel.action(.companionDidSelect(item.detailState))
    }

    private func hideBottomSheetAfterTransition() {
        guard let transitionCoordinator else {
            setBottomSheetHidden(true)
            setTabBarHidden(false)
            return
        }

        setBottomSheetHidden(true)
        setTabBarHidden(false)

        transitionCoordinator.animate(alongsideTransition: nil) { [weak self] context in
            guard context.isCancelled else { return }

            self?.setBottomSheetHidden(false)
            self?.setTabBarHidden(self?.isSpecificBottomSheetPresented == true)
        }
    }

    private func setBottomSheetHidden(_ isHidden: Bool) { bottomSheetViewController.view.isHidden = isHidden }

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

        if state.content != .specificRestaurantCompanionList,
           let tabBar = tabBarController?.tabBar {
            bottomSheetHostView.bringSubviewToFront(tabBar)
        }

        if state.level == .expanded {
            if state.content == .nearbyCompanionList {
                view.bringSubviewToFront(companionView.recruitCompanionButton)
            }

            return
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
