//
//  MeetingItem.swift
//  Nearby
//
//  Created by h2e on 7/8/26.
//

import Foundation

struct MeetingItem {
    let id: Int
    let matchId: Int
    let name: String
    let gender: String
    let profileImageUrl: String?
    let information: String
    let meetingDate: Date
    let postType: PostType
    let isCheckedIn: Bool
    
    private static let verifiableWindow: TimeInterval = 3600
    
    var isWithinVerifiableWindow: Bool {
        switch postType {
        case .scheduled:
            return abs(meetingDate.timeIntervalSinceNow) <= Self.verifiableWindow
        case .immediate:
            return Date() < meetingDate
        case .undecided:
            return false
        }
    }
    
    var step: MeetingStep {
        if isCheckedIn { return .completion }
        return isWithinVerifiableWindow ? .verification : .match
    }
    
    var cellType: MeetingVerificationCellType {
        (!isCheckedIn && isWithinVerifiableWindow) ? .verifiable : .notYet
    }
    
    
    var isExpiredWithoutCheckIn: Bool {
        guard !isCheckedIn else { return false }
        switch postType {
        case .scheduled:
            return meetingDate.addingTimeInterval(Self.verifiableWindow) < Date()
        case .immediate:
            return meetingDate < Date()
        case .undecided:
            return false
        }
    }
}
