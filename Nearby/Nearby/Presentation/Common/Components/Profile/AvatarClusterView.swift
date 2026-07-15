//
//  AvatarClusterView.swift
//  Nearby
//
//  Created by h2e on 7/12/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class AvatarClusterView: UIView {
    
    // MARK: - Properties
    
    private static let avatarOverlap: CGFloat = 8
    private var avatarCount: Int = 0
    private var currentAvatarSize: CGFloat {
        Self.avatarSize(for: avatarCount)
    }
    
    private var step: CGFloat { currentAvatarSize - Self.avatarOverlap }
    var contentSize: CGSize {
        Self.contentSize(for: avatarCount)
    }
    
    override var intrinsicContentSize: CGSize {
        contentSize
    }
    
    // MARK: - Initializer

    init() {
        super.init(frame: .zero)

        setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    static func contentSize(for count: Int) -> CGSize {
        let avatarCount = min(count, 4)
        let avatarSize = Self.avatarSize(for: avatarCount)
        let step = avatarSize - Self.avatarOverlap
        let width = avatarCount > 1 ? avatarSize + step : avatarSize
        let height = avatarCount > 2 ? avatarSize + step : avatarSize

        return CGSize(width: width, height: height)
    }

    private static func avatarSize(for count: Int) -> CGFloat {
        switch count {
        case 0:
            return 0
        case ...2:
            return 40
        case 3:
            return 36
        default:
            return 32
        }
    }
    
    private func offsets(for count: Int) -> [CGPoint] {
        switch count {
        case ...1:
            return [.zero]
        case 2:
            return [
                .zero,
                CGPoint(x: step, y: 0)
            ]
        case 3:
            return [
                CGPoint(x: 0, y: 0),
                CGPoint(x: step, y: 0),
                CGPoint(x: 0, y: step)
            ]
        default:
            return [
                CGPoint(x: 0, y: 0),
                CGPoint(x: step, y: 0),
                CGPoint(x: 0, y: step),
                CGPoint(x: step, y: step)
            ]
        }
    }
    
    private func makeAvatarView() -> UIImageView {
        UIImageView().then {
            $0.reset()
            $0.contentMode = .scaleAspectFill
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = currentAvatarSize / 2
            $0.clipsToBounds = true
        }
    }

    private func removeAvatarViews() {
        subviews.forEach {
            ($0 as? UIImageView)?.reset()
            $0.removeFromSuperview()
        }
    }
    
    func configure(with images: [UIImage?]) {
        configureAvatarViews(count: images.count) { avatarView, index in
            let image = images[index]
            if let image {
                avatarView.image = image
            }
        }
    }

    func configure(withImageURLs imageURLs: [String?]) {
        configureAvatarViews(count: imageURLs.count) { avatarView, index in
            let imageURL = imageURLs[index]
            if let imageURL,
               let url = URL(string: imageURL) {
                avatarView.kf.setImage(with: url, placeholder: UIImage.imgProfileDefault)
            }
        }
    }

    private func configureAvatarViews(count: Int, configure: (UIImageView, Int) -> Void) {
        removeAvatarViews()
        avatarCount = min(count, 4)

        offsets(for: avatarCount).enumerated().forEach { index, offset in
            let avatarView = makeAvatarView()
            configure(avatarView, index)
            addSubview(avatarView)
            avatarView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(offset.x)
                $0.top.equalToSuperview().offset(offset.y)
                $0.size.equalTo(currentAvatarSize)
            }
        }

        invalidateIntrinsicContentSize()
    }

    func reset() {
        removeAvatarViews()
        avatarCount = 0
        invalidateIntrinsicContentSize()
    }
}

private extension UIImageView {
    func reset() {
        kf.cancelDownloadTask()
        image = .imgProfileDefault
        backgroundColor = .clear
    }
}
