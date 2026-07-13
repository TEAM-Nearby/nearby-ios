//
//  CompanionProfileTarget.swift
//  Nearby
//

import Alamofire

enum CompanionProfileTarget {
    case detail(profileId: Int)
}

extension CompanionProfileTarget: BaseTargetType {
    var path: String {
        switch self {
        case .detail(let profileId):
            return "/api/companion-profiles/\(profileId)"
        }
    }

    var method: HTTPMethod { .get }
}
