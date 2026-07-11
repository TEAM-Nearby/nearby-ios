//
//  WrittenPostEmptyView.swift
//  Nearby
//
//  Created by 신서연 on 7/11/26.
//

import UIKit

import SnapKit
import Then

final class WrittenPostEmptyView: UIView {

    // MARK: - UI Components

    private let emptyImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
        setUI()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom Methods

private extension WrittenPostEmptyView {
    func setStyle() {
        backgroundColor = .white

        emptyImageView.do {
            $0.image = .illustLetterEmpty
            $0.contentMode = .scaleAspectFit
        }

        titleLabel.do {
            $0.font = NearbyFont.h1Sb24.font
            $0.text = "아직 직접 올린 모집글이 없어요"
            $0.textColor = .grey80
            $0.textAlignment = .center
            $0.numberOfLines = 1
        }

        descriptionLabel.do {
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }

        configureDescriptionLabel()
    }

    func setUI() {
        addSubviews(emptyImageView, titleLabel, descriptionLabel)
    }

    func setLayout() {
        emptyImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(218)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(184)
            $0.height.equalTo(124)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }

    func configureDescriptionLabel() {
        let text = """
        주변의 다른 이웃들이 올린 글을
        확인하고 먼저 올린 동행에 참여해 볼까요?
        """

        let font = NearbyFont.b2M16.font
        let lineHeight = font.pointSize * 1.4

        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.alignment = .center
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        let baselineOffset = (lineHeight - font.lineHeight) / 4

        descriptionLabel.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: font, .foregroundColor: UIColor.grey30,
                .paragraphStyle: paragraphStyle, .baselineOffset: baselineOffset
            ]
        )
    }
}
