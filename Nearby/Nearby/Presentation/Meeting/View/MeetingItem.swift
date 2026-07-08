//
//  MeetingItem.swift
//  Nearby
//
//  Created by h2e on 7/8/26.
//

import Foundation

struct MeetingItem {
    let id: Int
    let name: String
    let gender: String
    let information: String
    let meetingDate: Date
    let step: MeetingStep
}

// MARK: - Cell Type

extension MeetingItem {
    var cellType: MeetingVerificationCellType {
        guard step == .verification else { return .notYet }
        
        let verifiableWindow: TimeInterval = 3600
        let isInWindow = abs(meetingDate.timeIntervalSinceNow) <= verifiableWindow
        return isInWindow ? .verifiable : .notYet
    }
}
