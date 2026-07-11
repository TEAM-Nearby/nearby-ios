//
//  CompanionView.swift
//  Nearby
//
//  Created by soomin on 7/6/26.
//

import UIKit

import GoogleMaps
import SnapKit
import Then

final class CompanionView: BaseView {
    
    // MARK: - UI Components
    
    let mapView = NearbyMapViewFactory.makeMapView()
    private let topSectionView = CompanionTopSectionView()
    private let recruitCompanionButtonGradientLayer = CAGradientLayer()
    let companionCountChip = NearbyChipButton(style: .mapInfo, title: "내 주변 12개의 동행이 있어요", horizontalInset: 12)
    
    let recruitCompanionButton = UIButton()
    let mapContainerView = UIView()
    let currentLocationButton = UIButton()
    
    var categoryCollectionView: UICollectionView {
        topSectionView.categoryCollectionView
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        recruitCompanionButtonGradientLayer.frame = recruitCompanionButton.bounds
        recruitCompanionButtonGradientLayer.cornerRadius = recruitCompanionButton.bounds.height / 2
        recruitCompanionButton.layer.shadowPath = UIBezierPath(
            roundedRect: recruitCompanionButton.bounds,
            cornerRadius: recruitCompanionButton.bounds.height / 2).cgPath
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .white
        mapContainerView.backgroundColor = .white
        
        currentLocationButton.do {
            $0.setImage(.icMylocationBtn.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
        }

        recruitCompanionButton.do {
            var configuration = UIButton.Configuration.plain()
            var title = AttributedString("동행글 작성")
            title.font = NearbyFont.b2Sb16.font
            
            configuration.attributedTitle = title
            configuration.image = .plusIconHome.withRenderingMode(.alwaysTemplate)
            configuration.background.backgroundColor = .clear
            configuration.baseForegroundColor = .white
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 23)
            
            $0.configuration = configuration
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 27
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.16
            $0.layer.shadowOffset = CGSize(width: 0, height: 4)
            $0.layer.shadowRadius = 7
            
            recruitCompanionButtonGradientLayer.colors = NearbyGradient.buttonBackgroundColors
            recruitCompanionButtonGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            recruitCompanionButtonGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            $0.layer.insertSublayer(recruitCompanionButtonGradientLayer, at: 0)
        }
    }
    
    override func setUI() {
        mapContainerView.addSubview(mapView)
        addSubviews(mapContainerView, topSectionView, recruitCompanionButton)
    }
    
    override func setLayout() {
        mapContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topSectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        recruitCompanionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(12)
            $0.width.equalTo(142)
            $0.height.equalTo(44)
        }
    }
    
    // MARK: - Method
    
    func updateMapControls(for state: BottomSheetState) {
        let shouldShowMapControls = state.content == .nearbyCompanionList && state.level != .expanded

        companionCountChip.isHidden = !shouldShowMapControls
        currentLocationButton.isHidden = !shouldShowMapControls
        recruitCompanionButton.isHidden = !shouldShowMapControls || state.level == .compact

        if shouldShowMapControls && !recruitCompanionButton.isHidden {
            bringSubviewToFront(recruitCompanionButton)
        }
    }
    
    func setCategoryChipsHidden(_ isHidden: Bool) {
        categoryCollectionView.isHidden = isHidden
    }
}
