//
//  PostType.swift
//  Nearby
//
//  Created by h2e on 7/12/26.
//

import Foundation

enum PostType: Decodable {
    case scheduled
    case immediate(expirationTime: String)
    case undecided

    init(from decoder: Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(String.self)
        switch rawValue {
        case "SCHEDULED":
            self = .scheduled
        case "NOW":
            self = .immediate(expirationTime: "")
        default:
            self = .undecided
        }
    }
}

extension PostType {
    private static let verifiableWindow: TimeInterval = 3600
    
    func isVerifiable(meetingAt: Date?, now: Date = Date()) -> Bool {
        switch self {
        case .scheduled, .immediate:
            guard let meetingAt else { return false }
            return abs(meetingAt.timeIntervalSince(now)) <= Self.verifiableWindow
        case .undecided:
            return false
        }
    }
}
