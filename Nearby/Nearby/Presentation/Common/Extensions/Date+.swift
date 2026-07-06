//
//  Date+.swift
//  Nearby
//
//  Created by soomin on 7/2/26.
//

import Foundation

extension Date {
    func toFormattedString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
}
