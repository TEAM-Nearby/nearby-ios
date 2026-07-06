//
//  UIView+.swift
//  Nearby
//
//  Created by soomin on 7/2/26.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
    func setCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}
