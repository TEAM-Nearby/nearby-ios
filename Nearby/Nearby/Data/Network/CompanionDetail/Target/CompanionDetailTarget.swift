//
//  CompanionDetailTarget.swift
//  Nearby
//
//  Created by soomin on 7/13/26.
//

import Alamofire

enum CompanionDetailTarget {
    case detail(postId: Int)
    case apply(postId: Int)
}

extension CompanionDetailTarget: BaseTargetType {
    var path: String {
        switch self {
        case .detail(let postId):
            return "/api/companion-posts/\(postId)"
        case .apply(let postId):
            return "/api/companion-posts/\(postId)/companion-requests"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .detail:
            return .get
        case .apply:
            return .post
        }
    }

    var queryParameters: Parameters? { nil }
}
