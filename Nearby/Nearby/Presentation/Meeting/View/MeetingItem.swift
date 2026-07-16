//
//  MeetingItem.swift
//  Nearby
//
//  Created by h2e on 7/8/26.
//

import Foundation

struct MeetingItem {
    let id: Int
    let meetingId: Int?
    let matchId: Int
    let name: String
    let gender: String
    let profileImageUrl: String?
    let information: String
    let meetingDate: Date?
    let postType: PostType
    let isCheckedIn: Bool
    
    var isWithinVerifiableWindow: Bool {
        postType.isVerifiable(meetingAt: meetingDate)
    }
    
    var step: MeetingStep {
        if isCheckedIn { return .completion }
        return isWithinVerifiableWindow ? .verification : .match
    }
    
    var cellType: MeetingVerificationCellType {
        (!isCheckedIn && isWithinVerifiableWindow) ? .verifiable : .notYet
    }
}
