//
//  StarRatingView.swift
//  Nearby
//
//  Created by h2e on 7/4/26.
//

import UIKit

import SnapKit

class StarRatingView: BaseView {
    
    // MARK: - Properties
    
    let maxRating = 5
    private(set) var rating: Int = 0
    
    private var starImageViews: [UIImageView] = []
    private let stackView = UIStackView()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
    }
    
    override func setUI() {
        addSubview(stackView)
        
        (0..<maxRating).forEach { _ in
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            starImageViews.append(imageView)
            stackView.addArrangedSubview(imageView)
        }
        updateStars()
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    private func updateStars() {
        for (index, imageView) in starImageViews.enumerated() {
            let isFilled = index < rating
            imageView.image = UIImage(named: isFilled ? "big_star_select" : "big_star_default")
        }
    }
    
    func setRating(_ value: Int) {
        rating = max(0, min(value, maxRating))
        updateStars()
    }
}
