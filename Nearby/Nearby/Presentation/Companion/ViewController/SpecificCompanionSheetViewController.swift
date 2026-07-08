//
//  SpecificCompanionSheetViewController.swift
//  Nearby
//
//  Created by soomin on 7/8/26.
//

import UIKit

import SnapKit
import Then

final class SpecificCompanionSheetViewController: BaseViewController<EmptyViewModel> {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let placeImageView = UIImageView()
    private let stackView = UIStackView()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        view.backgroundColor = .white
        
        titleLabel.do {
            $0.setFont(.h3M20, text: "지영님 주변에서 동행을 구하고 있어요", textColor: .grey80)
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 12
        }
    }
    
    override func setUI() {
        view.addSubviews(titleLabel)
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
