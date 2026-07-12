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
        abs(meetingDate.timeIntervalSinceNow) <= Self.verifiableWindow
    }
    
    var step: MeetingStep {
        if isCheckedIn { return .completion }
        return isWithinVerifiableWindow ? .verification : .match
    }
    
    var cellType: MeetingVerificationCellType {
        (!isCheckedIn && isWithinVerifiableWindow) ? .verifiable : .notYet
    }
    
    var isExpiredWithoutCheckIn: Bool {
        !isCheckedIn && meetingDate.addingTimeInterval(Self.verifiableWindow) < Date()
    }
}
