//
//  HostCompanionTargetType.swift
//  Nearby
//
//  Created by h2e on 7/12/26.
//

import Alamofire
import Foundation

enum HostCompanionTargetType {
    case fetchDetail(applicationId: Int)
    case allow(applicationId: Int)
    case decline(applicationId: Int, rejectionReason: String?)
}

extension HostCompanionTargetType: BaseTargetType {
    
    var path: String {
        switch self {
        case .fetchDetail(let applicationId):
            return "/api/companion-requests/\(applicationId)/review"
        case .allow(let applicationId):
            return "/api/companion-requests/\(applicationId)/accept"
        case .decline(let applicationId, _):
            return "/api/companion-requests/\(applicationId)/reject"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchDetail:
            return .get
        case .allow, .decline:
            return .patch
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .decline(_, let rejectionReason):
            guard let rejectionReason, !rejectionReason.isBlank else { return nil }
            return ["rejectionReason": rejectionReason]
        case .fetchDetail, .allow:
            return nil
        }
    }
}
