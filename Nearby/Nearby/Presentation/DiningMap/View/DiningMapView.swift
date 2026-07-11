//
//  DiningMapView.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import UIKit

import GoogleMaps
import SnapKit
import Then

final class DiningMapView: BaseView {
    
    // MARK: - Properties
    
    let mapView = NearbyMapViewFactory.makeMapView()
    private let topSectionView = DiningMapTopSectionView()
    let currentLocationButton = UIButton()
    let bookmarkButton = UIButton()
    
    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        currentLocationButton.do {
            $0.setImage(.icMylocationBtn.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
        }
        
        bookmarkButton.do {
            $0.setBackgroundImage(.icBookmarkBtnUnselected.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.setBackgroundImage(.icBookmarkBtn.withRenderingMode(.alwaysOriginal), for: .selected)
            $0.isSelected = false
        }
    }

    override func setUI() {
        addSubviews(mapView, topSectionView, currentLocationButton, bookmarkButton)
    }

    override func setLayout() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        topSectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }

        currentLocationButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(8)
            $0.size.equalTo(40)
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.bottom.equalTo(currentLocationButton.snp.top).offset(-6)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(40)
        }
    }
}
