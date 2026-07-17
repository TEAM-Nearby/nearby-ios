//
//  CompanionTopSectionView.swift
//  Nearby
//
//  Created by soomin on 7/8/26.
//

import UIKit

import SnapKit
import Then

final class CompanionTopSectionView: BaseView {

    // MARK: - Properties

    var onAlarmButtonDidTap: (() -> Void)?
    private var showsAlarmPoint = false
    
    // MARK: - UI Components
    
    private let blurBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialLight))
    private let blurMaskLayer = CAGradientLayer()
    private let blurWhiteGradientView = UIView()
    private let blurWhiteGradientLayer = CAGradientLayer()
    private let navigationBar = NearbyNavigationBar()
    
    let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        blurMaskLayer.frame = blurBackgroundView.bounds
        blurWhiteGradientLayer.frame = blurWhiteGradientView.bounds
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .clear
        
        blurBackgroundView.do {
            $0.isUserInteractionEnabled = false
            
            blurMaskLayer.colors = [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
            blurMaskLayer.locations = [0, 0.55, 1]
            blurMaskLayer.startPoint = CGPoint(x: 0.5, y: 0)
            blurMaskLayer.endPoint = CGPoint(x: 0.5, y: 1)
            $0.layer.mask = blurMaskLayer
        }
        
        blurWhiteGradientView.do {
            $0.isUserInteractionEnabled = false
            
            blurWhiteGradientLayer.colors = [UIColor.white.withAlphaComponent(0.28).cgColor, UIColor.white.withAlphaComponent(0).cgColor]
            blurWhiteGradientLayer.locations = [0, 1]
            blurWhiteGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            blurWhiteGradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            $0.layer.addSublayer(blurWhiteGradientLayer)
        }
        
        navigationBar.do {
            $0.configure(leftItem: .logo, rightItems: [.alarmPoint])
            $0.backgroundColor = .clear
        }
        
        categoryCollectionView.do {
            if let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
                layout.minimumInteritemSpacing = 6
                layout.minimumLineSpacing = 6
                layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            }
            
            $0.backgroundColor = .clear
            $0.clipsToBounds = false
            $0.showsHorizontalScrollIndicator = false
        }
    }
    
    override func setUI() {
        addSubviews(blurBackgroundView, blurWhiteGradientView, navigationBar, categoryCollectionView)
    }
    
    override func setLayout() {
        blurBackgroundView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(102)
        }
        
        blurWhiteGradientView.snp.makeConstraints {
            $0.edges.equalTo(blurBackgroundView)
        }
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(14)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(NearbyChipStyle.category.height + 8)
        }
    }
    
    override func registerCells() {
        categoryCollectionView.register(NearbyChipCollectionViewCell.self)
    }

    override func setAddTarget() {
        navigationBar.rightFirstButtonAction = { [weak self] in
            self?.onAlarmButtonDidTap?()
        }

        navigationBar.logoAction = { [weak self] in
            guard let self else { return }
            showsAlarmPoint.toggle()
            navigationBar.updateRightItems([showsAlarmPoint ? .alarmPointRed : .alarmPoint])
        }
    }
}
