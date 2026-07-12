//
//  DiningInfoSheetView.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

import UIKit

import SnapKit
import Then

final class DiningInfoSheetView: BaseView {
    
    // MARK: - Properties
    
    var onBookmarkTap: (() -> Void)?
    var onCloseTap: (() -> Void)?
    
    // MARK: - UI Components
    
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let bookmarkButton = UIButton()
    private let closeButton = UIButton()
    
    private let starRatingView = StarRatingView()
    private let ratingLabel = UILabel()
    private let reviewCountLabel = UILabel()
    private let priceLabel = UILabel()
    
    private let dividerView = UIView()
    private let contentLabel = UILabel()
    private let addressLabel = UILabel()
    
    private let timeStackView = UIStackView()
    private let clockImageView = UIImageView()
    private let timeTitleLabel = UILabel()
    private let timeSubTitleLabel = UILabel()
    
    private let placeStackView = UIStackView()
    private let placeImageView = UIImageView()
    private let placeTitleLabel = UILabel()
    
    private let phoneStackView = UIStackView()
    private let phoneImageView = UIImageView()
    private let phoneLabel = UILabel()
    
    private lazy var imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    private var restaurantImages: [UIImage?] = []
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .white
        
        nameLabel.do {
            $0.setFont(.h3Sb20, textColor: .grey80)
        }
        
        categoryLabel.do {
            $0.setFont(.b3M14, textColor: .grey30)
        }
        
        bookmarkButton.do {
            $0.setImage(.bookmarkMini.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.setImage(.bookmarkChoosedMini.withRenderingMode(.alwaysOriginal), for: .selected)
        }
        
        closeButton.do {
            $0.setImage(.cancelCircleIcon, for: .normal)
        }
        
        starRatingView.do {
            $0.setSpacing(2)
            $0.setFilledStarColor(.chipIcOrange)
        }
        
        ratingLabel.do {
            $0.setFont(.b2Sb16, textColor: .chipIcOrange)
        }
        
        reviewCountLabel.do {
            $0.setFont(.b2M16, textColor: .grey30)
        }
        
        priceLabel.do {
            $0.setFont(.b2M16, textColor: .grey30)
        }
        
        contentLabel.do {
            $0.setFont(.b3M14, textColor: .grey80)
            $0.numberOfLines = 2
            $0.lineBreakMode = .byTruncatingTail
        }
        
        dividerView.backgroundColor = .grey5
        
        timeStackView.do {
            $0.axis = .horizontal
            $0.alignment = .top
            $0.spacing = 8
        }
        
        placeStackView.do {
            $0.axis = .horizontal
            $0.alignment = .top
            $0.spacing = 8
        }
        
        phoneStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 8
        }
        
        clockImageView.do {
            $0.image = .smallClockIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .grey80
        }
        
        placeImageView.do {
            $0.image = .smallLocationIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .grey80
        }
        
        phoneImageView.do {
            $0.image = .callIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .grey80
        }
        
        timeTitleLabel.do {
            $0.setFont(.b2Sb16, textColor: .grey80)
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        
        timeSubTitleLabel.do {
            $0.setFont(.b3M14, textColor: .grey40)
            $0.transform = CGAffineTransform(translationX: 0, y: 1)
        }
        
        placeTitleLabel.do {
            $0.setFont(.b3M14, textColor: .grey40)
            $0.numberOfLines = 2
            $0.lineBreakMode = .byTruncatingTail
        }
        
        phoneLabel.setFont(.b3M14, textColor: .grey40)
        
        imageCollectionView.do {
            $0.backgroundColor = .white
            $0.dataSource = self
            $0.showsHorizontalScrollIndicator = false
            $0.alwaysBounceHorizontal = true
            $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    override func setUI() {
        timeStackView.addArrangedSubviews(clockImageView, timeTitleLabel, timeSubTitleLabel)
        placeStackView.addArrangedSubviews(placeImageView, placeTitleLabel)
        phoneStackView.addArrangedSubviews(phoneImageView, phoneLabel)
        
        addSubviews(nameLabel, categoryLabel, bookmarkButton, closeButton,
                    starRatingView, ratingLabel, reviewCountLabel, priceLabel,
                    contentLabel, dividerView, timeStackView, placeStackView,
                    phoneStackView, imageCollectionView)
    }
    
    override func setLayout() {
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().inset(20)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(nameLabel)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(40)
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.centerY.equalTo(closeButton)
            $0.trailing.equalTo(closeButton.snp.leading)
            $0.size.equalTo(40)
        }
        
        starRatingView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(17)
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
        
        priceLabel.snp.makeConstraints {
            $0.leading.equalTo(reviewCountLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(starRatingView)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(starRatingView.snp.bottom).offset(14)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(NearbyFont.b3M14.property.lineHeight * 2)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        timeStackView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(14)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        placeStackView.snp.makeConstraints {
            $0.top.equalTo(timeStackView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(NearbyFont.b3M14.property.lineHeight * 2)
        }
        
        phoneStackView.snp.makeConstraints {
            $0.top.equalTo(placeStackView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        [clockImageView, placeImageView, phoneImageView].forEach {
            $0.snp.makeConstraints { $0.size.equalTo(20) }
        }
        
        imageCollectionView.snp.makeConstraints {
            $0.top.equalTo(phoneStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(214)
        }
    }
    
    override func setAddTarget() {
        bookmarkButton.addAction(UIAction { [weak self] _ in
            self?.onBookmarkTap?()
        }, for: .touchUpInside)
        closeButton.addAction(UIAction { [weak self] _ in
            self?.onCloseTap?()
        }, for: .touchUpInside)
    }
    
    override func registerCells() {
        imageCollectionView.register(DiningImageCell.self)
    }
    
    // MARK: - Methods
    
    private func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 187, height: 214)
        layout.minimumLineSpacing = 8
        return layout
    }
    
    func configure(with item: NearDiningCellItem, description: String, closingTime: String, phoneNumber: String, price: String) {
        nameLabel.text = item.name
        categoryLabel.text = item.category
        bookmarkButton.isSelected = item.isBookmarked
        starRatingView.setRating(Int(item.rating.rounded()))
        ratingLabel.text = String(format: "%.1f", item.rating)
        reviewCountLabel.text = "(\(item.reviewCount.formatted())) ·"
        priceLabel.text = price
        contentLabel.text = description
        timeTitleLabel.text = item.businessStatus
        timeSubTitleLabel.text = closingTime
        placeTitleLabel.text = "\(item.distance) · \(item.address)"
        phoneLabel.text = phoneNumber
        restaurantImages = item.images
        imageCollectionView.reloadData()
        imageCollectionView.layoutIfNeeded()
        imageCollectionView.setContentOffset(
            CGPoint(x: -imageCollectionView.contentInset.left, y: 0),
            animated: false
        )
    }
}

// MARK: - UICollectionViewDataSource

extension DiningInfoSheetView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        restaurantImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(DiningImageCell.self, for: indexPath)
        cell.configure(image: restaurantImages[indexPath.item])
        return cell
    }
}
