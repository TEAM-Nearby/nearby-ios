//
//  ProfileTarget.swift
//  Nearby
//

import Alamofire

enum ProfileTarget {
    case detail(profileId: Int)
}

extension ProfileTarget: BaseTargetType {
    var path: String {
        switch self {
        case .detail(let profileId):
            return "/api/companion-profiles/\(profileId)"
        }
    }

    var method: HTTPMethod { .get }
}
