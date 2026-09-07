//
//  ISO8601DateFormatter+.swift
//  Nearby
//
//  Created by h2e on 7/13/26.
//

import Foundation

extension ISO8601DateFormatter {
    static let withFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    static let standard = ISO8601DateFormatter()
}
