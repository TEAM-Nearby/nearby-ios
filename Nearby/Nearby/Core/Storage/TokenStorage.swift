//
//  TokenStorage.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

import Foundation

protocol TokenStorage {
    var accessToken: String? { get }
    var refreshToken: String? { get }

    func save(accessToken: String, refreshToken: String) throws
    func clear() throws
}

extension TokenStorage {
    var currentUserId: Int? {
        guard let accessToken else { return nil }

        let segments = accessToken.split(separator: ".")
        guard segments.count > 1 else { return nil }

        var payload = String(segments[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        payload += String(repeating: "=", count: (4 - payload.count % 4) % 4)

        guard
            let data = Data(base64Encoded: payload),
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { return nil }

        if let subject = json["sub"] as? String {
            return Int(subject)
        }
        if let subject = json["sub"] as? NSNumber {
            return subject.intValue
        }
        return nil
    }
}
