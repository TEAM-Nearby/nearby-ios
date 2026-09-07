//
//  SaveDiningCell.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import UIKit

import SnapKit
import Then

final class SaveDiningCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var onBookmarkTap: (() -> Void)?
    var onImageTap: (() -> Void)?

    // MARK: - UI Components

    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let distanceLabel = UILabel()
    private let addressLabel = UILabel()
    private let bookmarkButton = UIButton()
    private lazy var imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    private var restaurantImages: [UIImage?] = []
    private var restaurantImageURLs: [URL?] = []
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
        restaurantImageURLs = []
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
        
        distanceLabel.do {
            $0.setFont(.b3R14, textColor: .grey50)
        }
        
        addressLabel.do {
            $0.setFont(.b3R14, textColor: .grey50)
            $0.lineBreakMode = .byTruncatingTail
        }
        
        bookmarkButton.do {
            $0.setImage(.bookmarkMini.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.setImage(.bookmarkSelectedMini.withRenderingMode(.alwaysOriginal), for: .selected)
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
        contentView.addSubviews(nameLabel, categoryLabel, distanceLabel, addressLabel, bookmarkButton, imageCollectionView, dividerView)
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
            $0.centerY.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(40)
        }
        
        distanceLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(distanceLabel.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().inset(95)
            $0.centerY.equalTo(distanceLabel)
        }
        
        imageCollectionView.snp.makeConstraints {
            $0.top.equalTo(distanceLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(115)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(imageCollectionView.snp.bottom).offset(16)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    private func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 115, height: 115)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    private func resetImageCollectionViewOffset() {
        imageCollectionView.setContentOffset(CGPoint(x: -imageCollectionView.contentInset.left, y: 0), animated: false)
    }
    
    func configure(with item: NearDiningCellItem, isLast: Bool) {
        nameLabel.text = item.name
        categoryLabel.text = item.category
        distanceLabel.text = item.distance
        addressLabel.text = "· \(item.address)"
        bookmarkButton.isSelected = item.isBookmarked
        dividerView.isHidden = isLast
        restaurantImages = item.images
        restaurantImageURLs = item.imageURLs
        imageCollectionView.reloadData()
        resetImageCollectionViewOffset()
    }
    
    // MARK: - Action
    
    @objc
    private func bookmarkButtonDidTap() {
        onBookmarkTap?()
    }
}

// MARK: - UICollectionViewDataSource

extension SaveDiningCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        restaurantImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(DiningImageCell.self, for: indexPath)
        let imageURL = restaurantImageURLs.indices.contains(indexPath.item)
            ? restaurantImageURLs[indexPath.item]
            : nil
        cell.configure(image: restaurantImages[indexPath.item], imageURL: imageURL)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SaveDiningCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onImageTap?()
    }
}
