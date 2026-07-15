//
//  AvatarStackView.swift
//  Nearby
//
//  Created by soomin on 7/8/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class AvatarStackView: UIStackView {
  
    // MARK: - Properties

    let avatarSize: CGFloat
    let avatarOverlap: CGFloat
  
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

    init(avatarSize: CGFloat = 16, avatarOverlap: CGFloat = 6) {
        self.avatarSize = avatarSize
        self.avatarOverlap = avatarOverlap
        super.init(frame: .zero)

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
        removeAvatarViews()

        images.forEach { image in
            addAvatarImageView {
                if let validImage = image {
                    $0.image = validImage
                    $0.backgroundColor = .clear
                } else {
                    $0.image = .imgProfileDefault
                    $0.backgroundColor = .clear
                }
            }
        }

        invalidateIntrinsicContentSize()
    }

    func configure(withImageURLs imageURLs: [String?]) {
        removeAvatarViews()

        imageURLs.forEach { imageURL in
            addAvatarImageView { avatarImageView in
                if let imageURL,
                   let url = URL(string: imageURL) {
                    avatarImageView.kf.setImage(with: url, placeholder: UIImage.imgProfileDefault)
                }
            }
        }

        invalidateIntrinsicContentSize()
    }

    func configureWithDefaultAvatars(count: Int) {
        let defaultImages = [UIImage?](repeating: nil, count: count)
        configure(with: defaultImages)
    }

    func reset() {
        removeAvatarViews()
        invalidateIntrinsicContentSize()
    }

    private func removeAvatarViews() {
        arrangedSubviews.forEach {
            ($0 as? UIImageView)?.reset()
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    private func addAvatarImageView(_ configure: (UIImageView) -> Void) {
        let avatarImageView = UIImageView().then {
            $0.reset()
            $0.contentMode = .scaleAspectFill
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = avatarSize / 2
            $0.clipsToBounds = true
        }

        configure(avatarImageView)
        addArrangedSubview(avatarImageView)

        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(avatarSize).priority(.high)
        }
    }
}

private extension UIImageView {
    func reset() {
        kf.cancelDownloadTask()
        image = .imgProfileDefault
        backgroundColor = .clear
    }
}
