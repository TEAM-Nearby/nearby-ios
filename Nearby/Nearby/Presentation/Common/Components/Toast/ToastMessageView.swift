//
//  ToastMessageView.swift
//  Nearby
//
//  Created by h2e on 7/14/26.
//

import UIKit

import SnapKit
import Then

final class ToastMessageView: BaseView {

    // MARK: - UI Components

    private let contentStackView = UIStackView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()

    // MARK: - Initializer

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .grey30

        contentStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
        }

        iconImageView.do {
            $0.image = .imgCheck
            $0.contentMode = .scaleAspectFit
        }

        titleLabel.do {
            $0.setFont(.b2Sb16, textColor: .white)
        }
    }

    override func setUI() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubviews(iconImageView, titleLabel)
    }

    override func setLayout() {
        contentStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        iconImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
}
