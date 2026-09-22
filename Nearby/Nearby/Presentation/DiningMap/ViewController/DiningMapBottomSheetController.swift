//
//  DiningMapBottomSheetController.swift
//  Nearby
//
//  Created by soomin on 9/22/26.
//

import CoreLocation
import UIKit

import SnapKit

final class DiningMapBottomSheetController {

    // MARK: - Properties

    var onEvent: ((DiningMapBottomSheetEvent) -> Void)?

    private(set) var screenState: DiningMapScreenState = .list(.nearby)

    private let bottomSheetViewController = NearbyBottomSheetViewController()
    private let nearDiningSheetViewController: NearDiningSheetViewController
    private let saveDiningSheetViewController: SaveDiningSheetViewController
    private let diningInfoSheetViewController: DiningInfoSheetViewController
    private var isInitialized = false

    var view: UIView { bottomSheetViewController.view }

    // MARK: - Initializer

    init(
        nearDiningSheetViewController: NearDiningSheetViewController,
        saveDiningSheetViewController: SaveDiningSheetViewController,
        diningInfoSheetViewController: DiningInfoSheetViewController
    ) {
        self.nearDiningSheetViewController = nearDiningSheetViewController
        self.saveDiningSheetViewController = saveDiningSheetViewController
        self.diningInfoSheetViewController = diningInfoSheetViewController
        bindEvents()
    }

    // MARK: - Methods

    func install(in parentViewController: UIViewController, hostView: UIView, lowerOverlayView: UIView, upperOverlayView: UIView) {
        parentViewController.addChild(bottomSheetViewController)
        hostView.addSubview(bottomSheetViewController.view)
        bottomSheetViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        bottomSheetViewController.setTrailingOverlayViews(lowerView: lowerOverlayView, upperView: upperOverlayView)
        bottomSheetViewController.didMove(toParent: parentViewController)
    }

    func initializeIfNeeded() {
        guard !isInitialized else { return }
        isInitialized = true
        showList(.nearby, animated: false, isReturningFromDetail: true)
    }

    func setHidden(_ isHidden: Bool) {
        bottomSheetViewController.view.isHidden = isHidden
    }

    func toggleList() {
        let nextList: DiningMapListType = screenState.listType == .saved ? .nearby : .saved
        showList(nextList)
    }

    func selectRestaurant(placeId: Int) {
        let item: NearDiningCellItem?
        switch screenState.listType {
        case .nearby:
            item = nearDiningSheetViewController.restaurant(placeId: placeId)
        case .saved:
            item = saveDiningSheetViewController.restaurant(placeId: placeId)
        }

        guard let item else { return }
        showDetail(item)
    }

    func updateLocation(_ coordinate: CLLocationCoordinate2D) {
        nearDiningSheetViewController.updateLocation(coordinate)
        saveDiningSheetViewController.updateLocation(coordinate)
    }

    private func bindEvents() {
        bottomSheetViewController.onStateChange = { [weak self] _, state in
            self?.onEvent?(.bottomSheetStateChanged(state))
        }

        nearDiningSheetViewController.onEvent = { [weak self] event in
            self?.handle(event, source: .nearby)
        }

        saveDiningSheetViewController.onEvent = { [weak self] event in
            self?.handle(event, source: .saved)
        }

        diningInfoSheetViewController.onEvent = { [weak self] event in
            self?.handle(event, source: nil)
        }
    }

    private func handle(_ event: DiningMapSheetEvent, source: DiningMapListType?) {
        switch event {
        case .restaurantSelected(let item):
            showDetail(item)
        case .markersChanged(let markers):
            guard let source else { return }
            guard source == screenState.listType else { return }
            onEvent?(.markersChanged(markers))
        case .favoriteUpdated(let placeId, let isFavorite):
            synchronizeFavorite(placeId: placeId, isFavorite: isFavorite, source: source)
        case .closeDetail:
            showList(screenState.listType, isReturningFromDetail: true)
        }
    }

    private func synchronizeFavorite(placeId: Int, isFavorite: Bool, source: DiningMapListType?) {
        if source != .nearby {
            nearDiningSheetViewController.updateFavorite(placeId: placeId, isFavorite: isFavorite)
        }
        if source != .saved {
            saveDiningSheetViewController.updateFavorite(placeId: placeId, isFavorite: isFavorite)
        }
    }

    private func showList(_ listType: DiningMapListType, animated: Bool = true, isReturningFromDetail: Bool = false) {
        screenState = .list(listType)

        if !isReturningFromDetail {
            onEvent?(.markersChanged(markers(for: listType)))
            if listType == .saved {
                saveDiningSheetViewController.refresh()
            }
        }

        bottomSheetViewController.setState(content: screenState.bottomSheetContent, animated: animated)
        bottomSheetViewController.setContentViewController(viewController(for: listType))
        onEvent?(.screenStateChanged(screenState))
    }

    private func showDetail(_ item: NearDiningCellItem, animated: Bool = true) {
        screenState = .detail(item: item, source: screenState.listType)
        diningInfoSheetViewController.configure(with: item)
        bottomSheetViewController.setState(content: screenState.bottomSheetContent, animated: animated)
        bottomSheetViewController.setContentViewController(diningInfoSheetViewController)
        onEvent?(.screenStateChanged(screenState))
    }

    private func markers(for listType: DiningMapListType) -> [CompanionMapMarkerData] {
        switch listType {
        case .nearby:
            return nearDiningSheetViewController.currentMapMarkers()
        case .saved:
            return saveDiningSheetViewController.currentMapMarkers()
        }
    }

    private func viewController(for listType: DiningMapListType) -> UIViewController {
        switch listType {
        case .nearby:
            return nearDiningSheetViewController
        case .saved:
            return saveDiningSheetViewController
        }
    }
}
