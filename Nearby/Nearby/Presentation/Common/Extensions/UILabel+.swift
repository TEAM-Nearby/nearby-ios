//
//  UILabel+.swift
//  Nearby
//
//  Created by soomin on 7/3/26.
//

import UIKit

extension UILabel {
    func setFont(_ nearbyFont: NearbyFont, text: String = "", textColor: UIColor = .black) {
        self.font = nearbyFont.font
        self.textColor = textColor
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = nearbyFont.property.lineHeight
        paragraphStyle.maximumLineHeight = nearbyFont.property.lineHeight
        paragraphStyle.alignment = textAlignment
        
        let baselineOffset = (nearbyFont.property.lineHeight - nearbyFont.font.lineHeight) / 4
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: nearbyFont.font,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: baselineOffset,
            .foregroundColor: textColor
        ]
        
        self.attributedText = NSAttributedString(string: text, attributes: attributes)
    }

    func setFont(_ nearbyFont: NearbyFont, text: String, textColor: UIColor = .black, lineSpacing: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.alignment = textAlignment

        attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: nearbyFont.font,
                .foregroundColor: textColor,
                .paragraphStyle: paragraphStyle
            ]
        )
    }
    
    func setRequiredTitle(_ title: String) {
        let attributedString = NSMutableAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor.grey80,
                .font: NearbyFont.b2Sb16.font
            ]
        )
        
        attributedString.append(
            NSAttributedString(
                string: "*",
                attributes: [
                    .foregroundColor: UIColor.highlightRed,
                    .font: NearbyFont.b2Sb16.font
                ]
            )
        )
        
        self.attributedText = attributedString
    }
}
