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
    
    static func makeInformation(placeName: String, meetingDate: Date?, timeZoneID: String? = nil) -> String {
        let timeText = meetingDate.map { date in
            let timeZone = timeZoneID.flatMap(TimeZone.init(identifier:)) ?? .nearbyAPITimeZone
            let calendar = Calendar(identifier: .gregorian)
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.timeZone = timeZone
            formatter.dateFormat = calendar.dateComponents(in: timeZone, from: date).minute == 0 ? "a h시" : "a h시 m분"
            return formatter.string(from: date)
        }

        return [placeName, timeText]
            .compactMap { $0 }
            .joined(separator: " · ")
    }
}
