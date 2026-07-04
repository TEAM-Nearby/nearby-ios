//
//  StarRatingView.swift
//  Nearby
//
//  Created by h2e on 7/4/26.
//

import UIKit

import SnapKit
import Then

class StarRatingView: BaseView {
    
    // MARK: - Properties
    
    let maxRating = 5
    private(set) var rating: Int = 0
    
    private var starImageViews: [UIImageView] = []
    private let stackView = UIStackView()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 20
            $0.distribution = .fillEqually
        }
    }
    
    override func setUI() {
        addSubview(stackView)
        
        (0..<maxRating).forEach { _ in
            let imageView = UIImageView().then {
                $0.contentMode = .scaleAspectFit
            }
            
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
    
    func rating(at point: CGPoint) -> Int {
        let convertedPoint = convert(point, to: stackView)
        var count = 0
        for imageView in starImageViews where convertedPoint.x >= imageView.frame.minX {
            count += 1
        }
        return count
    }
}
