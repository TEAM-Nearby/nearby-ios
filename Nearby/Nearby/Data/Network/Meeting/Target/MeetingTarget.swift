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
}

extension MeetingTarget: BaseTargetType {
    var path: String {
        switch self {
        case .fetchMeetingList:
            return "/api/companion-meetings"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchMeetingList:
            return .get
        }
    }
}
