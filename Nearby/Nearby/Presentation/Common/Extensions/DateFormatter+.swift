//
//  DateFormatter+.swift
//  Nearby
//
//  Created by h2e on 7/12/26.
//

import Foundation

extension DateFormatter {
    private static var cache: [String: DateFormatter] = [:]
    
    static func cached(format: String) -> DateFormatter {
        if let cachedFormatter = cache[format] { return cachedFormatter }
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        cache[format] = formatter
        return formatter
    }
}
