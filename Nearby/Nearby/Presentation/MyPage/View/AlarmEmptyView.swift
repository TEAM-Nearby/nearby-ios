//
//  AlarmEmptyView.swift
//  Nearby
//
//  Created by 신서연 on 7/11/26.
//


import UIKit

import SnapKit
import Then

final class AlarmEmptyView: UIView {

    // MARK: - UI Components

    private let emptyImageView = UIImageView()
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

    // MARK: - Method

    func configure(tab: AlarmTab) {
        switch tab {
        case .sent:
            configureSentRequestEmptyView()

        case .received:
            configureReceivedRequestEmptyView()
        }
    }
}

// MARK: - Custom Methods

private extension AlarmEmptyView {
    func setStyle() {
        backgroundColor = .white

        emptyImageView.do {
            $0.contentMode = .scaleAspectFit
        }

        titleLabel.do {
            $0.font = NearbyFont.h1Sb24.font
            $0.textColor = .grey80
            $0.textAlignment = .center
            $0.numberOfLines = 1
        }

        descriptionLabel.do {
            $0.font = NearbyFont.b2M16.font
            $0.textColor = .grey40
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
    }

    func setUI() {
        addSubviews(emptyImageView, titleLabel, descriptionLabel)
    }

    func configureSentRequestEmptyView() {
        emptyImageView.image = UIImage(
            named: "illust_empty_bench"
        )

        titleLabel.text = "보낸 요청이 없어요"

        descriptionLabel.text = """
        동행 지도에서 함께하고 싶은
        여행자를 찾아보세요!
        """

        setLayout(
            imageTopOffset: 164,
            imageSize: CGSize(width: 186, height: 115),
            titleToDescriptionSpacing: 16
        )
    }

    func configureReceivedRequestEmptyView() {
        emptyImageView.image = UIImage(
            named: "illust_letter_empty"
        )

        titleLabel.text = "받은 요청이 없어요"

        descriptionLabel.text = """
        아직 받은 합류 요청이 없어요.
        새 요청이 오면 알려드릴게요!
        """

        setLayout(
            imageTopOffset: 156,
            imageSize: CGSize(width: 184, height: 124),
            titleToDescriptionSpacing: 8
        )
    }

    func setLayout(imageTopOffset: CGFloat, imageSize: CGSize, titleToDescriptionSpacing: CGFloat)
    {
        emptyImageView.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(imageTopOffset)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(imageSize)
        }

        titleLabel.snp.remakeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        descriptionLabel.snp.remakeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
                .offset(titleToDescriptionSpacing)

            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}
