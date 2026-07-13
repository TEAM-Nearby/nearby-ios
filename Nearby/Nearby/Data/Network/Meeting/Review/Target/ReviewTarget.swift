//
//  ReviewTarget.swift
//  Nearby
//
//  Created by h2e on 7/14/26.
//

import Alamofire

enum ReviewTarget {
    case create(meetingId: Int, request: CreateReviewRequestDTO)
}

extension ReviewTarget: BaseTargetType {
    var path: String {
        switch self {
        case .create(let meetingId, _):
            return "/api/companion-meetings/\(meetingId)/reviews"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .create:
            return .post
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
        }
    }
}
