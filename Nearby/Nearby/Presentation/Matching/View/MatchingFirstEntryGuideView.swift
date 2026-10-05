//
//  MatchingFirstEntryGuideView.swift
//  Nearby
//
//  Created by 장지인 on 10/4/26.
//

import UIKit

import SnapKit
import Then

final class MatchingFirstEntryGuideView: BaseView {

    // MARK: - UI Components

    private let backgroundButton = UIButton()
    private let closeButton = UIButton(type: .system)
    private let sampleCard = MatchingMatchedCardCell(frame: .zero)
    private let arrowImageView = UIImageView()
    private let guideLabel = UILabel()

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = UIColor.black.withAlphaComponent(0.75)

        sampleCard.configure(content: MatchingMatchedCardItem.sample.content)

        closeButton.do {
            $0.setImage(.cancelIcon.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .white
        }

        arrowImageView.do {
            $0.image = UIImage(named: "akar-icons_arrow-back")
            $0.contentMode = .scaleAspectFit
        }

        guideLabel.do {
            $0.setFont(.b3Sb14, text: "클릭하면 매칭된 동행을 볼 수 있어요!", textColor: .white)
            $0.setHighlight(target: "매칭된 동행", color: .primary30)
        }
    }

    override func setUI() {
        addSubviews(backgroundButton, closeButton, sampleCard, arrowImageView, guideLabel)
    }

    override func setLayout() {
        backgroundButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        closeButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(30)
        }

        sampleCard.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(184)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(MatchingMatchedCardCell.height(for: MatchingMatchedCardItem.sample.content))
        }

        arrowImageView.snp.makeConstraints {
            $0.top.equalTo(sampleCard.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(40)
            $0.size.equalTo(24)
        }

        guideLabel.snp.makeConstraints {
            $0.centerY.equalTo(arrowImageView)
            $0.leading.equalTo(arrowImageView.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
        }
    }

    override func setAddTarget() {
        backgroundButton.addTarget(self, action: #selector(dismissGuide), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(dismissGuide), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc
    private func dismissGuide() {
        removeFromSuperview()
    }
}
