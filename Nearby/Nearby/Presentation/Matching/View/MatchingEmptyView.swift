//
//  MatchingEmptyView.swift
//  Nearby
//
//  Created by 장지인 on 7/9/26.
//

import UIKit

import Lottie
import SnapKit
import Then

final class MatchingEmptyView: BaseView {

    // MARK: - UI Components

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let animationView = LottieAnimationView(name: "EmptyHere")
    let findCompanionButton = NearbyButton(style: .primary, title: "내 주변의 동행 찾아보기")

    // MARK: - Custom Methods

    override func setStyle() {
        animationView.do {
            $0.backgroundColor = .clear
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .loop
            $0.backgroundBehavior = .pauseAndRestore
        }

        titleLabel.do {
            $0.setFont(.h1Sb24, text: "매칭된 동행이 없어요!", textColor: .grey80)
            $0.textAlignment = .center
        }

        descriptionLabel.do {
            $0.setFont(.b2M16, text: "아래 버튼을 클릭해서\n함께 밥 먹을 동행을 구해보세요", textColor: .grey40)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
    }

    override func setUI() {
        addSubviews(animationView, titleLabel, descriptionLabel, findCompanionButton)
    }

    override func setLayout() {
        animationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.top.equalToSuperview().inset(65)
            $0.height.equalTo(animationView.snp.width)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(animationView.snp.bottom).offset(-70)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(28)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
        }

        findCompanionButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }
    }
    
    // MARK: - Methods
    
    func playAnimationIfNeeded() {
        guard !animationView.isAnimationPlaying else { return }
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: .loop)
    }

    func stopAnimation() {
        animationView.stop()
    }
}
