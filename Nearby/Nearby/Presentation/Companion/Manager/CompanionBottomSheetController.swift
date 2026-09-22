//
//  CompanionBottomSheetController.swift
//  Nearby
//
//  Created by soomin on 9/21/26.
//

import CoreLocation
import UIKit

import SnapKit

final class CompanionBottomSheetController {
    
    // MARK: - Properties
    
    var onStateChange: ((BottomSheetState) -> Void)?
    var onCompanionSelected: ((CompanionDetailState) -> Void)?
    var onSummaryTextChanged: ((String) -> Void)?
    var onMapMarkersChanged: (([CompanionMapMarkerData]) -> Void)?
    var onSpecificSheetClose: (() -> Void)?
    
    private let bottomSheetViewController = NearbyBottomSheetViewController()
    private let nearbySheetViewController: NearCompanionSheetViewController
    private let specificSheetViewController: SpecificCompanionSheetViewController
    private let emptySheetViewController: EmptyCompanionSheetViewController
    private var displayedContent: BottomSheetContent?
    
    // MARK: - Initializer
    
    init(nearbySheetViewController: NearCompanionSheetViewController, specificSheetViewController: SpecificCompanionSheetViewController, emptySheetViewController: EmptyCompanionSheetViewController) {
        self.nearbySheetViewController = nearbySheetViewController
        self.specificSheetViewController = specificSheetViewController
        self.emptySheetViewController = emptySheetViewController
        bind()
    }
    
    // MARK: - Methods
    
    private func bind() {
        bottomSheetViewController.onStateChange = { [weak self] _, state in
            self?.onStateChange?(state)
        }
        
        nearbySheetViewController.onCompanionSelected = { [weak self] item in
            self?.onCompanionSelected?(item.detailState)
        }
        nearbySheetViewController.onSummaryTextChanged = { [weak self] summaryText in
            self?.onSummaryTextChanged?(summaryText)
        }
        nearbySheetViewController.onMapMarkersChanged = { [weak self] markers in
            self?.onMapMarkersChanged?(markers)
        }
        nearbySheetViewController.onTitleMultilineChanged = { [weak self] isMultiline in
            self?.updateHeight(for: .nearbyCompanionList, isTitleMultiline: isMultiline)
        }
        
        specificSheetViewController.onClose = { [weak self] in
            self?.onSpecificSheetClose?()
        }
        specificSheetViewController.onCompanionSelected = { [weak self] item in
            self?.onCompanionSelected?(item.detailState)
        }
        specificSheetViewController.onTitleMultilineChanged = { [weak self] isMultiline in
            self?.updateHeight(for: .specificRestaurantCompanionList, isTitleMultiline: isMultiline)
        }
    }
    
    private func updateHeight(for content: BottomSheetContent, isTitleMultiline: Bool) {
        let adjustment = isTitleMultiline ? NearbyBottomSheetValue.nearCompanionTitleHeight : 0
        DispatchQueue.main.async { [weak self] in
            self?.bottomSheetViewController.setHeightAdjustment(adjustment, for: content)
        }
    }
    
    func attach(to parentViewController: UIViewController, in hostView: UIView, centerOverlayView: UIView, trailingOverlayView: UIView) {
        parentViewController.addChild(bottomSheetViewController)
        hostView.addSubview(bottomSheetViewController.view)
        
        bottomSheetViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomSheetViewController.setTopOverlayViews(centerView: centerOverlayView, trailingView: trailingOverlayView)
        bottomSheetViewController.didMove(toParent: parentViewController)
    }
    
    func render(_ state: BottomSheetState, animated: Bool = true) {
        bottomSheetViewController.setState(state, animated: animated)
        guard displayedContent != state.content else { return }
        
        displayedContent = state.content
        switch state.content {
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
    
    func updateNickname(_ nickname: String) {
        nearbySheetViewController.updateNickname(nickname)
        specificSheetViewController.updateNickname(nickname)
    }
    
    func updateLocation(_ coordinate: CLLocationCoordinate2D) {
        nearbySheetViewController.updateLocation(coordinate)
    }
    
    func updatePlaceCategory(_ category: CompanionPlace.Category) {
        nearbySheetViewController.updatePlaceCategory(category)
    }
    
    func updateSpecificCompanions(for placeId: Int) {
        specificSheetViewController.updateCompanions(nearbySheetViewController.specificCompanions(for: placeId))
    }
    
    func setHidden(_ isHidden: Bool) {
        bottomSheetViewController.view.isHidden = isHidden
    }
    
    func bringToFront(in hostView: UIView) {
        hostView.bringSubviewToFront(bottomSheetViewController.view)
    }
}
