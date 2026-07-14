//
//  CompanionRequestTarget.swift
//  Nearby
//
//  Created by 신서연 on 7/14/26.
//

import Alamofire

enum CompanionRequestTarget {
    case list(direction: CompanionRequestDirection)
    case markNotificationAsRead(notificationId: Int)
}

extension CompanionRequestTarget: BaseTargetType {

    var path: String {
        switch self {
        case .list:
            return "/api/users/me/companion-requests"

        case .markNotificationAsRead(let notificationId):
            return "/api/users/me/companion-requests/\(notificationId)/read"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list:
            return .get

        case .markNotificationAsRead:
            return .patch
        }
    }

    var queryParameters: Parameters? {
        switch self {
        case .list(let direction):
            return ["direction": direction.rawValue]

        case .markNotificationAsRead:
            return nil
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .list, .markNotificationAsRead:
            return nil
        }
    }

    var requiresAuth: Bool {
        true
    }
}
