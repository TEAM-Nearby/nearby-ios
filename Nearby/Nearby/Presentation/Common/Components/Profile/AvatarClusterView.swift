//
//  AvatarClusterView.swift
//  Nearby
//
//  Created by h2e on 7/12/26.
//

import UIKit

import SnapKit
import Then

final class AvatarClusterView: UIView {
    
    // MARK: - Properties
    
    private let avatarSize: CGFloat = 32
    private let overlap: CGFloat = 9
    
    private var step: CGFloat { avatarSize - overlap }
    private var clusterSide: CGFloat { avatarSize + step }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: clusterSide, height: clusterSide)
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
    
    private func offsets(for count: Int) -> [CGPoint] {
        switch count {
        case ...1:
            return [CGPoint(x: step / 2, y: step / 2)]
        case 2:
            return [
                CGPoint(x: 0, y: step / 2),
                CGPoint(x: step, y: step / 2)
            ]
        case 3:
            return [
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0, y: step),
                CGPoint(x: step, y: step / 2)
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
    
    private func makeAvatarView(image: UIImage?) -> UIImageView {
        UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = avatarSize / 2
            $0.clipsToBounds = true
            $0.image = image
            $0.backgroundColor = image == nil ? .grey20 : .clear
        }
    }
    
    func configure(with images: [UIImage?]) {
        subviews.forEach { $0.removeFromSuperview() }
        
        zip(images.prefix(4), offsets(for: images.count)).forEach { image, offset in
            let avatarView = makeAvatarView(image: image)
            addSubview(avatarView)
            avatarView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(offset.x)
                $0.top.equalToSuperview().offset(offset.y)
                $0.size.equalTo(avatarSize)
            }
        }
    }
}
