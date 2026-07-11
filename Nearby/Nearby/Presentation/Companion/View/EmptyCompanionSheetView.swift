//
//  EmptyCompanionSheetView.swift
//  Nearby
//
//  Created by soomin on 7/9/26.
//

import UIKit

import SnapKit
import Then

final class EmptyCompanionSheetView: BaseView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .white
        
        titleLabel.do {
            $0.setFont(.h3Sb20, text: "주변에 아직 열린 동행이 없어요\n동네 혼밥지도를 확인해볼까요?")
            $0.numberOfLines = 0
        }
        
        imageView.do {
            $0.image = .illustMainEmpty
            $0.contentMode = .scaleAspectFit
        }
    }
    
    override func setUI() {
        addSubviews(titleLabel, imageView)
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(196)
            $0.height.equalTo(112)
        }
    }
}
