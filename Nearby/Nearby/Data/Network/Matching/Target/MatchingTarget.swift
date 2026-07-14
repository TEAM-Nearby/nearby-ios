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
        }
    }

    var method: HTTPMethod { .get }

    var queryParameters: Parameters? { nil }
}
