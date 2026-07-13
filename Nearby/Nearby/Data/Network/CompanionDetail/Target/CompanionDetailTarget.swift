//
//  CompanionDetailTarget.swift
//  Nearby
//
//  Created by soomin on 7/13/26.
//

import Alamofire

enum CompanionDetailTarget {
    case detail(postId: Int)
}

extension CompanionDetailTarget: BaseTargetType {
    var path: String {
        switch self {
        case .detail(let postId):
            return "/api/companion-posts/\(postId)"
        }
    }

    var method: HTTPMethod { .get }

    var queryParameters: Parameters? { nil }
}
