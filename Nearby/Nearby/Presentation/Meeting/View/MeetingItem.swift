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
    var isWithinVerifiableWindow: Bool {
        abs(meetingDate.timeIntervalSinceNow) <= 3600
    }
    var cellType: MeetingVerificationCellType {
        guard step == .verification else { return .notYet }
        
        return isWithinVerifiableWindow ? .verifiable : .notYet
    }
}
