//
//  MeetingTarget.swift
//  Nearby
//
//  Created by h2e on 7/13/26.
//

import Foundation
import Alamofire

enum MeetingTarget {
    case fetchMeetingList
    case fetchMeetingDetail(meetingId: Int)
}

extension MeetingTarget: BaseTargetType {
    var path: String {
        switch self {
        case .fetchMeetingList:
            return "/api/companion-meetings"
        case .fetchMeetingDetail(let meetingId):
            return "/api/companion-meetings/\(meetingId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchMeetingList, .fetchMeetingDetail:
            return .get
        }
    }
}
