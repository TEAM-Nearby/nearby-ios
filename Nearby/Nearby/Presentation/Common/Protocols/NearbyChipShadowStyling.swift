//
//  NearbyChipShadowStyling.swift
//  Nearby
//
//  Created by soomin on 7/7/26.
//

import UIKit

protocol NearbyChipShadowStyling: AnyObject {}

extension NearbyChipShadowStyling where Self: UIView {
    func applyChipShadow(style: NearbyChipStyle) {
        clipsToBounds = false
        layer.borderWidth = 1
        layer.cornerRadius = style.layerCornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = style.shadowOffset
        layer.shadowRadius = style.shadowRadius
        layer.shadowOpacity = style.shadowOpacity
        isUserInteractionEnabled = style.isSelectable
    }

    func updateChipShadowPath(style: NearbyChipStyle) {
        let shadowRect = bounds.offsetBy(dx: 0, dy: style.shadowOffset.height / 2)
        
        layer.shadowPath = UIBezierPath(
            roundedRect: shadowRect,
            cornerRadius: style.layerCornerRadius
        ).cgPath
    }
}
