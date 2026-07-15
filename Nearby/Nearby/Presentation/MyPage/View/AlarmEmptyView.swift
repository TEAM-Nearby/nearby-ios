//
//  AlarmEmptyView.swift
//  Nearby
//
//  Created by 신서연 on 7/11/26.
//

import UIKit

import Lottie
import SnapKit
import Then

final class AlarmEmptyView: UIView {

    // MARK: - UI Components

    private let animationView = LottieAnimationView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
        setUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(tab: AlarmTab) {
        switch tab {
        case .sent:
            configureSentRequestEmptyView()

        case .received:
            configureReceivedRequestEmptyView()
        }

        animationView.play(fromProgress: 0, toProgress: 1, loopMode: .loop)
    }
}

// MARK: - Custom Methods

private extension AlarmEmptyView {
    func setStyle() {
        backgroundColor = .white

        animationView.do {
            $0.backgroundColor = .clear
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .loop
            $0.backgroundBehavior = .pauseAndRestore
        }

        titleLabel.do {
            $0.font = NearbyFont.h1Sb24.font
            $0.textColor = .grey80
            $0.textAlignment = .center
            $0.numberOfLines = 1
        }

        descriptionLabel.do {
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
    }

    func setUI() {
        addSubviews(animationView, titleLabel, descriptionLabel)
    }

    func configureSentRequestEmptyView() {
        animationView.animation = LottieAnimation.named("EmptyHere")

        titleLabel.text = "보낸 요청이 없어요"

        setDescriptionText(
            """
            동행 지도에서 함께하고 싶은
            여행자를 찾아보세요!
            """
        )

        setLayout(
            imageTopOffset: 164,
            titleToDescriptionSpacing: 16
        )
    }

    func configureReceivedRequestEmptyView() {
        animationView.animation = LottieAnimation.named("PostNone")

        titleLabel.text = "받은 요청이 없어요"

        setDescriptionText(
            """
            아직 받은 합류 요청이 없어요.
            새 요청이 오면 알려드릴게요!
            """
        )

        setLayout(
            imageTopOffset: 156,
            titleToDescriptionSpacing: 8
        )
    }

    func setDescriptionText(_ text: String) {
        let font = NearbyFont.b2M16.font
        let lineHeight = font.pointSize * 1.4

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        let baselineOffset = (
            lineHeight - font.lineHeight
        ) / 4

        descriptionLabel.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: font,
                .foregroundColor: UIColor.grey40,
                .paragraphStyle: paragraphStyle,
                .baselineOffset: baselineOffset
            ]
        )
    }

    func setLayout(
        imageTopOffset: CGFloat,
        titleToDescriptionSpacing: CGFloat
    ) {
        animationView.snp.remakeConstraints {
            $0.top.equalToSuperview().inset(50)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(animationView.snp.width)
        }

        titleLabel.snp.remakeConstraints {
            $0.top.equalTo(animationView.snp.bottom).offset(-70)

            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        descriptionLabel.snp.remakeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(titleToDescriptionSpacing)

            $0.horizontalEdges.equalToSuperview().inset(40)

            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}
