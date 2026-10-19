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
    private var filledStarColor: UIColor?
    
    private var starImageViews: [UIImageView] = []
    private let stackView = UIStackView()
    private var partialStarImageView: UIImageView?
    private var partialStarContainerView: UIView?
    private var partialStarWidthConstraint: Constraint?
    private var displayRating: Double = 0
    
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
        partialStarContainerView?.removeFromSuperview()
        partialStarContainerView = nil
        partialStarImageView = nil
        partialStarWidthConstraint = nil

        for (index, imageView) in starImageViews.enumerated() {
            let fillAmount = max(0, min(1, displayRating - Double(index)))
            let isFilled = fillAmount >= 1
            let image = UIImage(resource: isFilled ? .bigStarSelect : .bigStarDefault)
            imageView.image = isFilled && filledStarColor != nil
                ? image.withRenderingMode(.alwaysTemplate)
                : image
            imageView.tintColor = isFilled ? filledStarColor : nil

            if fillAmount > 0 && fillAmount < 1 {
                addPartialStar(to: imageView, fillAmount: fillAmount)
            }
        }
    }
    
    private func addPartialStar(to imageView: UIImageView, fillAmount: Double) {
        let containerView = UIView()
        containerView.clipsToBounds = true
        containerView.isUserInteractionEnabled = false

        let filledImageView = UIImageView()
        filledImageView.contentMode = .scaleAspectFit

        let image = UIImage(resource: .bigStarSelect)

        filledImageView.image = filledStarColor != nil ? image.withRenderingMode(.alwaysTemplate) : image

        filledImageView.tintColor = filledStarColor

        imageView.addSubview(containerView)
        containerView.addSubview(filledImageView)

        containerView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            partialStarWidthConstraint = $0.width.equalTo(imageView.snp.width).multipliedBy(fillAmount).constraint
        }

        filledImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(imageView.snp.width)
        }

        partialStarContainerView = containerView
        partialStarImageView = filledImageView
    }
    
    func setRating(_ value: Int) {
        rating = max(0, min(value, maxRating))
        displayRating = Double(rating)
        updateStars()
    }
    
    func setRating(_ value: Double) {
        displayRating = max(0, min(value, Double(maxRating)))
        updateStars()
    }

    func setSpacing(_ spacing: CGFloat) {
        stackView.spacing = spacing
    }

    func setFilledStarColor(_ color: UIColor) {
        filledStarColor = color
        updateStars()
    }
    
    func rating(at point: CGPoint) -> Int {
        let convertedPoint = convert(point, to: stackView)
        return starImageViews.filter { convertedPoint.x >= $0.frame.minX }.count
    }
}
