//
//  WrittenPostKeywordCell.swift
//  Nearby
//
//  Created by soomin on 7/15/26.
//

import UIKit

import SnapKit
import Then

final class WrittenPostKeywordCell: UICollectionViewCell {

    // MARK: - Property

    private let titleLabel = UILabel()

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

    // MARK: - Life Cycle

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

    // MARK: - Methods

    private func setStyle() {
        contentView.do {
            $0.backgroundColor = .primary50.withAlphaComponent(0.10)
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
        }

        titleLabel.do {
            $0.font = NearbyFont.b3M14.font
            $0.textColor = .primary50
            $0.textAlignment = .center
            $0.numberOfLines = 1
        }
    }

    private func setUI() {
        contentView.addSubview(titleLabel)
    }

    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}
