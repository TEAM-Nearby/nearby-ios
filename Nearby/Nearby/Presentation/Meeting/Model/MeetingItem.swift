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
    
    var cellType: MeetingVerificationCellType {
        guard meetingId != nil else { return .notYet }
        return (!isCheckedIn && isWithinVerifiableWindow) ? .verifiable : .notYet
    }
}

extension MeetingItem {
    static func makeInformation(placeName: String, meetingDate: Date?) -> String {
        [placeName, meetingDate?.timeDisplayText]
            .compactMap { $0 }
            .joined(separator: " · ")
    }
}
