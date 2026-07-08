//
//  CompanionNearbyBottomSheetViewController.swift
//  Nearby
//
//  Created by soomin on 7/8/26.
//

import UIKit

import SnapKit
import Then

final class CompanionNearbyBottomSheetViewController: BaseViewController<EmptyViewModel> {
    
    // MARK: - UI Component
    
    private let titleLabel = UILabel()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        view.backgroundColor = .white
        
        titleLabel.do {
            $0.setFont(.h3Sb20, text: "지영님 주변에서 동행을 구하고 있어요", textColor: .grey80)
        }
    }
    
    override func setUI() {
        view.addSubview(titleLabel)
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
