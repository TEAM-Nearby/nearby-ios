//
//  DateFormatter+.swift
//  Nearby
//
//  Created by h2e on 7/12/26.
//

import Foundation

extension DateFormatter {
    private static var cache: [String: DateFormatter] = [:]
    
    static func cached(format: String, timeZone: TimeZone? = .current) -> DateFormatter {
        let key = "\(format)|\(timeZone?.identifier ?? "current")"
        if let cachedFormatter = cache[key] { return cachedFormatter }

        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = timeZone
        cache[key] = formatter
        return formatter
    }
}
