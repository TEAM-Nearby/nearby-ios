//
//  MatchedCompanionListTarget.swift
//  Nearby
//
//  Created by 장지인 on 7/13/26.
//

import Foundation

import Alamofire

enum MatchedCompanionListTarget {
    case matches
    case preview(matchId: Int)
    case detail(matchId: Int)
    case confirmSchedule(matchId: Int, request: ConfirmCompanionScheduleRequestDTO)
}

extension MatchedCompanionListTarget: BaseTargetType {
    var path: String {
        switch self {
        case .matches:
            return "/api/companion-matches"
        case .preview(let matchId):
            return "/api/companion-matches/\(matchId)/preview"
        case .detail(let matchId):
            return "/api/companion-matches/\(matchId)/schedule"
        case .confirmSchedule(let matchId, _):
            return "/api/companion-matches/\(matchId)/schedule"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .matches, .preview, .detail:
            return .get
        case .confirmSchedule:
            return .post
        }
    }

    var queryParameters: Parameters? { nil }

    var bodyParameters: Parameters? {
        switch self {
        case .confirmSchedule(_, let request):
            return [
                "scheduledAt": request.scheduledAt,
                "place": [
                    "googlePlaceId": request.place.googlePlaceId,
                    "name": request.place.name,
                    "address": request.place.address,
                    "latitude": request.place.latitude,
                    "longitude": request.place.longitude
                ],
                "openChatUrl": request.openChatUrl
            ]
        case .matches, .preview, .detail:
            return nil
        }
    }
}
