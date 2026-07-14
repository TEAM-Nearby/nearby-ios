//
//  ReviewTarget.swift
//  Nearby
//
//  Created by h2e on 7/14/26.
//

import Alamofire

enum ReviewTarget {
    case create(meetingId: Int, request: CreateReviewRequestDTO)
    case fetchTargets(meetingId: Int)
    case complete(meetingId: Int)
}

extension ReviewTarget: BaseTargetType {
    var path: String {
        switch self {
        case .create(let meetingId, _):
            return "/api/companion-meetings/\(meetingId)/reviews"
        case .fetchTargets(let meetingId):
            return "/api/companion-meetings/\(meetingId)/review-targets"
        case .complete(let meetingId):
            return "/api/companion-meetings/\(meetingId)/complete"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .create:
            return .post
        case .fetchTargets:
            return .get
        case .complete:
            return .patch
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .create(_, let request):
            return [
                "revieweeUserId": request.revieweeUserId,
                "rating": request.rating,
                "keywords": request.keywords
            ]
        case .fetchTargets, .complete:
            return nil
        }
    }
}
