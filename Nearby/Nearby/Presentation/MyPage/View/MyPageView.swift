//
//  MyPageView.swift
//  Nearby
//
//  Created by 신서연 on 7/9/26.
//


//
//  MyPageView.swift
//  Nearby
//
//  Created by 신서연 on 7/9/26.
//

import UIKit

import SnapKit
import Then

final class MyPageView: BaseView {
    
    // MARK: - Properties
    
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - UI Components
    
    let navigationBar = NearbyNavigationBar()
    
    // MARK: - Life Cycles
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .clear
        
        gradientLayer.do {
            $0.colors = [
                UIColor(hex: "#DCD7FF").cgColor,
                UIColor(hex: "#FAFAFF").cgColor
            ]
            $0.startPoint = CGPoint(x: 0.5, y: 0.0)
            $0.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
        
        navigationBar.do {
            $0.backgroundColor = .clear
            $0.configure(
                centerItem: .title("마이페이지"),
                rightItems: [.alarm, .setting]
            )
        }
    }
    
    override func setUI() {
        layer.insertSublayer(gradientLayer, at: 0)
        
        addSubview(navigationBar)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}