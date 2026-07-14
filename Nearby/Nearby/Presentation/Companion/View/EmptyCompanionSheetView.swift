//
//  EmptyCompanionSheetView.swift
//  Nearby
//
//  Created by soomin on 7/9/26.
//

import UIKit

import Lottie
import SnapKit
import Then

final class EmptyCompanionSheetView: BaseView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let animationView = LottieAnimationView(name: "MainEmpty")
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .white
        
        titleLabel.do {
            $0.setFont(.h3Sb20, text: "주변에 아직 열린 동행이 없어요\n동네 혼밥지도를 확인해볼까요?")
            $0.numberOfLines = 0
        }
        
        animationView.do {
            $0.backgroundColor = .clear
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .loop
            $0.backgroundBehavior = .pauseAndRestore
        }
    }
    
    override func setUI() {
        addSubviews(titleLabel, animationView)
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        animationView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(-50)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(300)
        }
    }

    func restartAnimation() {
        animationView.stop()
        animationView.currentProgress = 0
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: .loop)
    }
}
