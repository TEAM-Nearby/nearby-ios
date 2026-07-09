//
//  String+.swift
//  Nearby
//
//  Created by soomin on 7/2/26.
//

import UIKit

extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isBlank: Bool {
        trimmed.isEmpty
    }

    func truncated(limit: Int, trailingText: String = "...") -> String {
        guard count > limit else {
            return self
        }

        return String(prefix(limit)) + trailingText
    }
    
    func withLineHeightMultiple(_ multiple: CGFloat, font: UIFont, color: UIColor) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = multiple
        
        return NSAttributedString(
            string: self,
            attributes: [
                .paragraphStyle: style,
                .font: font,
                .foregroundColor: color
            ]
        )
    }
}
