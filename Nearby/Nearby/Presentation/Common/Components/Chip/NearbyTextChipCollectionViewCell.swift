//
//  NearbyTextChipCollectionViewCell.swift
//  Nearby
//
//  Created by 장지인 on 7/7/26.
//

import UIKit
import SnapKit

final class NearbyTextChipCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Component

    private var chipButton: NearbyChipButton?

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Method

    override func prepareForReuse() {
        super.prepareForReuse()

        chipButton?.removeFromSuperview()
        chipButton = nil
    }

    // MARK: - Method
    
    private func setStyle() {
        clipsToBounds = false
        contentView.clipsToBounds = false
        contentView.backgroundColor = .clear
    }

    func configure(style: NearbyChipStyle, title: String, horizontalInset: CGFloat) {
        chipButton?.removeFromSuperview()

        let chipButton = NearbyChipButton(style: style, title: title, horizontalInset: horizontalInset)
        chipButton.isUserInteractionEnabled = false

        contentView.addSubview(chipButton)

        chipButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.chipButton = chipButton
    }
}
