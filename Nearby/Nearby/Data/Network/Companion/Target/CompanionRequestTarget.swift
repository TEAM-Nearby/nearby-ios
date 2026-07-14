//
//  CompanionRequestTarget.swift
//  Nearby
//
//  Created by 신서연 on 7/14/26.
//


import Alamofire

enum CompanionRequestTarget {
    case list(direction: CompanionRequestDirection)
}

extension CompanionRequestTarget: BaseTargetType {

    var path: String {
        switch self {
        case .list:
            return "/api/users/me/companion-requests"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        }
    }

    var queryParameters: Parameters? {
        switch self {
        case .list(let direction):
            return ["direction": direction.rawValue]
        }
    }

    var requiresAuth: Bool {
        true
    }
}
