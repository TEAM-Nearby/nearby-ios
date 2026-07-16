//
//  DiningImageCell.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class DiningImageCell: UICollectionViewCell {
    
    // MARK: - UI Component
    
    private let imageView = UIImageView()

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .grey5
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

    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }

    // MARK: - Method
    
    func configure(image: UIImage?, imageURL: URL?) {
        imageView.kf.cancelDownloadTask()
        imageView.image = image

        guard let imageURL else {
            return
        }

        imageView.kf.setImage(with: imageURL, placeholder: image)
    }
}
