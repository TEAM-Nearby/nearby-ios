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
    case checkIn(meetingId: Int, latitude: Double, longitude: Double)
    case report(meetingId: Int, request: CreateMeetingReportRequestDTO)
}

extension MeetingTarget: BaseTargetType {
    var path: String {
        switch self {
        case .fetchMeetingList:
            return "/api/companion-meetings"
        case .fetchMeetingDetail(let meetingId):
            return "/api/companion-meetings/\(meetingId)"
        case .checkIn(let meetingId, _, _):
            return "/api/companion-meetings/\(meetingId)/check-in"
        case .report(let meetingId, _):
            return "/api/companion-meetings/\(meetingId)/reports"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchMeetingList, .fetchMeetingDetail:
            return .get
        case .checkIn, .report:
            return .post
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .checkIn(_, let latitude, let longitude):
            return ["latitude": latitude, "longitude": longitude]
        case .report(_, let request):
            var parameters: Parameters = [
                "reportedUserId": request.reportedUserId,
                "reasons": request.reasons
            ]
            if let detail = request.detail {
                parameters["detail"] = detail
            }
            return parameters
        case .fetchMeetingList, .fetchMeetingDetail:
            return nil
        }
    }
}
