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

        return String(prefix(max(limit - 1, 0))) + trailingText
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
    
    func toDate() -> Date? {
        if let date = ISO8601DateFormatter.withFractionalSeconds.date(from: self) { return date }
        if let date = ISO8601DateFormatter.standard.date(from: self) { return date }
        let utc = TimeZone(secondsFromGMT: 0)
        if let date = DateFormatter.cached(format: "yyyy-MM-dd'T'HH:mm:ss.SSSSSS", timeZone: utc).date(from: self) { return date }
        return DateFormatter.cached(format: "yyyy-MM-dd'T'HH:mm:ss", timeZone: utc).date(from: self)
    }
}
