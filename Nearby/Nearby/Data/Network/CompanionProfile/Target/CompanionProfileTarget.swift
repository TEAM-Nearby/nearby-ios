//
//  CompanionProfileTarget.swift
//  Nearby
//
//  Created by h2e on 10/14/26.
//

import Alamofire

enum CompanionProfileTarget {
    case update(request: UpdateCompanionProfileRequestDTO)
}

extension CompanionProfileTarget: BaseTargetType {
    var path: String {
        switch self {
        case .update:
            return "/api/users/me/companion-profile"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .update:
            return .put
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .update(let request):
            var parameters: Parameters = [
                "nickname": request.nickname,
                "travelStyleKeywords": request.travelStyleKeywords
            ]
            if let intro = request.intro {
                parameters["intro"] = intro
            }
            if let profileImageURL = request.profileImageURL {
                parameters["profileImageUrl"] = profileImageURL
            }
            return parameters
        }
    }
}
