//
//  DiningImageCell.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import UIKit

import SnapKit
import Then

final class DiningImageCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let imageView = UIImageView()

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycles
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    // MARK: - Methods
    
    func configure(image: UIImage?) {
        imageView.image = image ?? .restaurantPlaceholder
    }
}
