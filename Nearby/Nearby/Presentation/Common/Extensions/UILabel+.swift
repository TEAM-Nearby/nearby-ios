//
//  UILabel+.swift
//  Nearby
//
//  Created by mandoo on 7/3/26.
//

import UIKit

extension UILabel {
    func setFont(_ nearbyFont: NearbyFont, text: String?, textColor: UIColor = .black) {
        self.font = nearbyFont.font
        self.textColor = textColor
        
        guard let text else {
            self.attributedText = nil
            return
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = nearbyFont.property.lineHeight
        paragraphStyle.maximumLineHeight = nearbyFont.property.lineHeight
        
        let baselineOffset = (nearbyFont.property.lineHeight - nearbyFont.font.lineHeight) / 4
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: nearbyFont.font,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: baselineOffset,
            .foregroundColor: textColor
        ]
        
        self.attributedText = NSAttributedString(string: text, attributes: attributes)
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
