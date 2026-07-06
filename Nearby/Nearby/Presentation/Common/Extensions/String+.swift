//
//  String+.swift
//  Nearby
//
//  Created by soomin on 7/2/26.
//

import Foundation

extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isBlank: Bool {
        trimmed.isEmpty
    }
}
