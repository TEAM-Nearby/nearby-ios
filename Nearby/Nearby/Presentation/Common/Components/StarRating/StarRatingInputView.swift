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
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panStar(_:)))
        addGestureRecognizer(pan)
    }
    
    // MARK: - Life Cycle
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        let velocity = pan.velocity(in: self)
        return abs(velocity.x) > abs(velocity.y)
    }
    
    // MARK: - Actions
    
    @objc
    private func tapStar(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        updateRating(to: rating(at: location))
    }
    
    @objc
    private func panStar(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        updateRating(to: rating(at: location))
    }
    
    // MARK: - Method
    
    private func updateRating(to newRating: Int) {
        guard newRating != rating else { return }
        setRating(newRating)
        onRatingChanged?(rating)
    }
}
