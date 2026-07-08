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
    
    private let topSectionView = CompanionTopSectionView()
    private let recruitCompanionButtonGradientLayer = CAGradientLayer()
    private let companionCountChip = NearbyChipButton(style: .mapInfo, title: "내 주변 12개의 동행이 있어요", horizontalInset: 12)
    
    let recruitCompanionButton = UIButton()
    let mapContainerView = UIView()
    let currentLocationButton = UIButton()
    
    var categoryCollectionView: UICollectionView {
        topSectionView.categoryCollectionView
    }
    
    let mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 37.531821, longitude: 126.913904, zoom: 15.0)
        let options = GMSMapViewOptions()
        options.camera = camera
        
        let mapView = GMSMapView(options: options)
        mapView.isMyLocationEnabled = false
        mapView.settings.myLocationButton = false
        return mapView
    }()
    
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
        addSubviews(mapContainerView, topSectionView, currentLocationButton, companionCountChip, recruitCompanionButton)
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
        
        companionCountChip.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(70)
        }
        
        currentLocationButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(companionCountChip)
            $0.size.equalTo(40)
        }
        
        recruitCompanionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(12)
            $0.width.equalTo(142)
            $0.height.equalTo(44)
        }
    }
    
    // MARK: - Method
    
    func updateMapControls(bottomInset: CGFloat, state: BottomSheetState) {
        companionCountChip.snp.updateConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(bottomInset)
        }
        
        companionCountChip.isHidden = state.level == .expanded
        currentLocationButton.isHidden = state.level == .expanded
        recruitCompanionButton.isHidden = state.content != .nearbyCompanionList || state.level == .compact
    }
    
}
