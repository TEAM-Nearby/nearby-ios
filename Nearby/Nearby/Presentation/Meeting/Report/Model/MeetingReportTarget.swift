//
//  MeetingReportTarget.swift
//  Nearby
//
//  Created by h2e on 10/9/26.
//

enum MeetingReportTarget {
    case meeting(id: Int, reportedUserID: Int?)
    case match(id: Int, reportedUserID: Int?)

    var reportedUserID: Int? {
        switch self {
        case .meeting(_, let reportedUserID), .match(_, let reportedUserID):
            return reportedUserID
        }
    }
}
