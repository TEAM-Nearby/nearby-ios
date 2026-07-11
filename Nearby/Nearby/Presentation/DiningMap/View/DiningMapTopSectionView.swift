//
//  DiningMapTopSectionView.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import UIKit

import SnapKit
import Then

final class DiningMapTopSectionView: BaseView {
    
    // MARK: - UI Components
    
    private let blurBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialLight))
    private let blurMaskLayer = CAGradientLayer()
    private let blurWhiteGradientView = UIView()
    private let blurWhiteGradientLayer = CAGradientLayer()
    private let navigationBar = NearbyNavigationBar()

    // MARK: - Life Cycles
    
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
    }

    override func setUI() {
        addSubviews(blurBackgroundView, blurWhiteGradientView, navigationBar)
    }

    override func setLayout() {
        blurBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        blurWhiteGradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
