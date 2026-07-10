//
//  AvatarStackView.swift
//  Nearby
//
//  Created by soomin on 7/8/26.
//

import UIKit

import SnapKit
import Then

final class AvatarStackView: UIStackView {
    let avatarSize: CGFloat = 16
    let avatarOverlap: CGFloat = 6

    var contentSize: CGSize {
        let avatarCount = arrangedSubviews.count
        guard avatarCount > 0 else { return .zero }

        let width = avatarSize + CGFloat(avatarCount - 1) * (avatarSize - avatarOverlap)
        return CGSize(width: width, height: avatarSize)
    }

    override var intrinsicContentSize: CGSize {
        contentSize
    }

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setStyle() {
        self.do {
            $0.axis = .horizontal
            $0.spacing = -avatarOverlap
            $0.alignment = .center
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentHuggingPriority(.required, for: .vertical)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
        }
    }

    func configure(with images: [UIImage?]) {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        images.forEach { image in
            let avatarImageView = UIImageView().then {
                $0.contentMode = .scaleAspectFill
                $0.layer.borderColor = UIColor.white.cgColor
                $0.layer.borderWidth = 1

                if let validImage = image {
                    $0.image = validImage
                    $0.backgroundColor = .clear
                } else {
                    $0.image = nil
                    $0.backgroundColor = .grey20
                }
            }

            addArrangedSubview(avatarImageView)

            avatarImageView.snp.makeConstraints { make in
                make.size.equalTo(avatarSize).priority(.high)
            }

            avatarImageView.layer.cornerRadius = avatarSize / 2
            avatarImageView.clipsToBounds = true
        }

        invalidateIntrinsicContentSize()
    }

    func configureWithDefaultAvatars(count: Int) {
        let defaultImages = [UIImage?](repeating: nil, count: count)
        configure(with: defaultImages)
    }
}
