//
//  AppIntroductionPageCell.swift
//  Nearby
//
//  Created by soomin on 10/2/26.
//
import UIKit

import SnapKit
import Then

final class AppIntroductionPageCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let imageView = UIImageView()
    
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
    
    // MARK: - Methods
    
    private func setStyle() {
        backgroundColor = .bgDefaultGrey
        contentView.backgroundColor = .bgDefaultGrey
        
        titleLabel.do {
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        descriptionLabel.do {
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        imageView.do {
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }
    }
    
    private func setUI() {
        contentView.addSubviews(titleLabel, descriptionLabel, imageView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(67)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
    }
    
    private func makeAttributedTitle(for page: AppIntroductionPage) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.minimumLineHeight = NearbyFont.h1B24.property.lineHeight
        paragraphStyle.maximumLineHeight = NearbyFont.h1B24.property.lineHeight
        
        let attributedTitle = NSMutableAttributedString(
            string: page.title,
            attributes: [
                .font: NearbyFont.h1B24.font,
                .foregroundColor: UIColor.grey90,
                .paragraphStyle: paragraphStyle
            ]
        )
        
        page.highlightedTexts.forEach { text in
            let range = (page.title as NSString).range(of: text)
            guard range.location != NSNotFound else { return }
            attributedTitle.addAttribute(.foregroundColor, value: UIColor.primary50, range: range)
        }
        
        return attributedTitle
    }
    
    private func updateImageLayout(for page: AppIntroductionPage) {
        imageView.snp.remakeConstraints {
            $0.centerX.equalToSuperview()

            if page.imageName == "app_introduction_1" {
                $0.bottom.equalToSuperview()
            } else {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(73)
            }
        }
    }
    
    func configure(with page: AppIntroductionPage) {
        titleLabel.attributedText = makeAttributedTitle(for: page)
        descriptionLabel.setFont(.c1M12, text: page.description, textColor: .grey40)
        imageView.image = UIImage(named: page.imageName)
        updateImageLayout(for: page)
    }
}
