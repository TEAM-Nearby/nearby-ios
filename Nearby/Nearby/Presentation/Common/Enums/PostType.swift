//
//  PostType.swift
//  Nearby
//
//  Created by h2e on 7/12/26.
//

import Foundation

enum PostType: String, Decodable {
    case scheduled = "SCHEDULED"
    case immediate = "NOW"
    case undecided = "UNDECIDED"
}

extension PostType {
    private static let verifiableWindow: TimeInterval = 3600
    
    func isVerifiable(meetingAt: Date, now: Date = Date()) -> Bool {
        switch self {
        case .scheduled:
            return abs(meetingAt.timeIntervalSince(now)) <= Self.verifiableWindow
        case .immediate:
            return now < meetingAt
        case .undecided:
            return false
        }
    }
}
