//
//  StarRatingInputView.swift
//  Nearby
//
//  Created by h2e on 7/4/26.
//

import UIKit

final class StarRatingInputView: StarRatingView {
    
    // MARK: - Property
    
    var onRatingChanged: ((Int) -> Void)?
    
    // MARK: - Custom Method
    
    override func setUI() {
        super.setUI()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapStar(_:)))
        addGestureRecognizer(tap)
    }
    
    // MARK: - Action
    
    @objc
    private func tapStar(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        let starWidth = bounds.width / CGFloat(maxRating)
        let tappedStar = Int(location.x / starWidth) + 1
        
        setRating(tappedStar)
        onRatingChanged?(rating)
    }
}
