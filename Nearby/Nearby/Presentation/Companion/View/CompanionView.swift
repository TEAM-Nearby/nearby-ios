//
//  CompanionView.swift
//  Nearby
//
//  Created by soomin on 7/6/26.
//

import UIKit

import SnapKit
import Then

final class CompanionView: BaseView {
    
    // MARK: - UI Components
    
    private let blurBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialLight))
    private let blurMaskLayer = CAGradientLayer()
    private let blurWhiteGradientView = UIView()
    private let blurWhiteGradientLayer = CAGradientLayer()
    private let navigationBar = NearbyNavigationBar()
    private let recruitCompanionButtonGradientLayer = CAGradientLayer()
    private let companionCountChip = NearbyChipButton(style: .mapInfo, title: "내 주변 12개의 동행이 있어요", horizontalInset: 12)
    let recruitCompanionButton = UIButton()
    let mapContainerView = UIView()
    let currentLocationButton = UIButton()
    let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        blurMaskLayer.frame = blurBackgroundView.bounds
        blurWhiteGradientLayer.frame = blurWhiteGradientView.bounds
        recruitCompanionButtonGradientLayer.frame = recruitCompanionButton.bounds
        recruitCompanionButtonGradientLayer.cornerRadius = recruitCompanionButton.bounds.height / 2
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .white
        mapContainerView.backgroundColor = .white
        
        blurBackgroundView.do {
            $0.isUserInteractionEnabled = false
            
            blurMaskLayer.colors = [
                UIColor.black.cgColor,
                UIColor.black.cgColor,
                UIColor.clear.cgColor
            ]
            blurMaskLayer.locations = [0, 0.55, 1]
            blurMaskLayer.startPoint = CGPoint(x: 0.5, y: 0)
            blurMaskLayer.endPoint = CGPoint(x: 0.5, y: 1)
            $0.layer.mask = blurMaskLayer
        }
        
        blurWhiteGradientView.do {
            $0.isUserInteractionEnabled = false
            
            blurWhiteGradientLayer.colors = [
                UIColor.white.withAlphaComponent(0.28).cgColor,
                UIColor.white.withAlphaComponent(0).cgColor
            ]
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
        addSubviews(mapContainerView, blurBackgroundView, blurWhiteGradientView, navigationBar, categoryCollectionView,
                    currentLocationButton, companionCountChip, recruitCompanionButton)
    }
    
    override func setLayout() {
        mapContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        blurBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
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
            $0.height.equalTo(NearbyChipStyle.category.height + 8)
        }
        
        // TODO: - 동행 갯수 칩, 위치 조정 버튼 Bottom Sheet 기준으로 레이아웃 잡기
        
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
    
    override func registerCells() {
        categoryCollectionView.register(NearbyChipCollectionViewCell.self)
    }
}
