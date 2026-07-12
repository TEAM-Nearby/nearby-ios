//
//  NearDiningCell.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import UIKit

import SnapKit
import Then

final class NearDiningCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var onBookmarkTap: (() -> Void)?
    var onImageTap: (() -> Void)?

    // MARK: - UI Components
    
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let statusLabel = UILabel()
    private let distanceLabel = UILabel()
    private let addressLabel = UILabel()
    private let starRatingView = StarRatingView()
    private let ratingLabel = UILabel()
    private let reviewCountLabel = UILabel()
    private let bookmarkButton = UIButton()
    private lazy var imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    private var restaurantImages: [UIImage?] = []
    private let dividerView = UIView()

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        onBookmarkTap = nil
        onImageTap = nil
        restaurantImages = []
        resetImageCollectionViewOffset()
        imageCollectionView.reloadData()
    }

    // MARK: - Methods
    
    private func setStyle() {
        contentView.backgroundColor = .white
        
        nameLabel.do {
            $0.setFont(.b1Sb18, textColor: .grey80)
        }
        
        categoryLabel.do {
            $0.setFont(.b3M14, textColor: .grey30)
        }
        
        statusLabel.do {
            $0.setFont(.b3M14, textColor: .grey80)
        }
        
        distanceLabel.do {
            $0.setFont(.c1M14, textColor: .grey30)
        }
        
        addressLabel.do {
            $0.setFont(.b3R14, textColor: .grey50)
            $0.lineBreakMode = .byTruncatingTail
        }
        
        starRatingView.do {
            $0.setSpacing(2)
            $0.setFilledStarColor(.chipIcOrange)
        }
        
        ratingLabel.do {
            $0.setFont(.b3Sb14, textColor: .chipIcOrange)
            $0.transform = CGAffineTransform(translationX: 0, y: 1)
        }

        reviewCountLabel.do {
            $0.setFont(.b3M14, textColor: .grey30)
            $0.transform = CGAffineTransform(translationX: 0, y: 1)
        }
        
        bookmarkButton.do {
            $0.setImage(.bookmarkMini.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.setImage(.bookmarkChoosedMini.withRenderingMode(.alwaysOriginal), for: .selected)
            $0.addTarget(self, action: #selector(bookmarkButtonDidTap), for: .touchUpInside)
        }
        
        imageCollectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.showsHorizontalScrollIndicator = false
            $0.alwaysBounceHorizontal = true
            $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            $0.register(DiningImageCell.self)
        }
        
        dividerView.do {
            $0.backgroundColor = .grey20
        }
    }
    
    // MARK: - Methods

    private func setUI() {
        contentView.addSubviews(nameLabel, categoryLabel, statusLabel, distanceLabel, addressLabel, starRatingView, ratingLabel, reviewCountLabel, bookmarkButton, imageCollectionView, dividerView)
    }

    private func setLayout() {
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(nameLabel)
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(29)
            $0.size.equalTo(40)
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(nameLabel)
        }
        
        distanceLabel.snp.makeConstraints {
            $0.leading.equalTo(statusLabel.snp.trailing).offset(6)
            $0.centerY.equalTo(statusLabel)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(statusLabel.snp.bottom).offset(4)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(86)
        }
        
        starRatingView.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(6)
            $0.leading.equalTo(nameLabel)
            $0.width.equalTo(80)
            $0.height.equalTo(16)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.leading.equalTo(starRatingView.snp.trailing).offset(4)
            $0.centerY.equalTo(starRatingView)
        }
        
        reviewCountLabel.snp.makeConstraints {
            $0.leading.equalTo(ratingLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(starRatingView)
        }
        
        imageCollectionView.snp.makeConstraints {
            $0.top.equalTo(starRatingView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(124)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(imageCollectionView.snp.bottom).offset(16)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }

    func configure(with item: NearDiningCellItem, isLast: Bool) {
        nameLabel.text = item.name
        categoryLabel.text = item.category
        statusLabel.text = item.businessStatus
        distanceLabel.text = item.distance
        addressLabel.text = item.address
        starRatingView.setRating(Int(item.rating.rounded()))
        ratingLabel.text = String(format: "%.1f", item.rating)
        reviewCountLabel.text = "(\(item.reviewCount.formatted()))"
        bookmarkButton.isSelected = item.isBookmarked
        dividerView.isHidden = isLast
        restaurantImages = item.images
        imageCollectionView.reloadData()
        resetImageCollectionViewOffset()
    }
    
    private func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 124, height: 124)
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 0
        return layout
    }

    private func resetImageCollectionViewOffset() {
        imageCollectionView.setContentOffset(CGPoint(x: -imageCollectionView.contentInset.left, y: 0), animated: false)
    }
    
    // MARK: - Action

    @objc
    private func bookmarkButtonDidTap() {
        onBookmarkTap?()
    }
}

// MARK: - UICollectionViewDataSource

extension NearDiningCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        restaurantImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(DiningImageCell.self, for: indexPath)
        cell.configure(image: restaurantImages[indexPath.item])
        
        return cell
    }
}

extension NearDiningCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onImageTap?()
    }
}
