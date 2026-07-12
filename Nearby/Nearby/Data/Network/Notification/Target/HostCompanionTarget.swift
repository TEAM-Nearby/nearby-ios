//
//  HostCompanionTarget.swift
//  Nearby
//
//  Created by h2e on 7/12/26.
//

import Foundation

import Alamofire

enum HostCompanionTarget {
    case fetchDetail(applicationId: Int)
    case allow(applicationId: Int)
    case reject(applicationId: Int, request: HostCompanionRejectRequestDTO)
}

extension HostCompanionTarget: BaseTargetType {
    var path: String {
        switch self {
        case .fetchDetail(let applicationId):
            return "/api/companion-requests/\(applicationId)/review"
        case .allow(let applicationId):
            return "/api/companion-requests/\(applicationId)/accept"
        case .reject(let applicationId, _):
            return "/api/companion-requests/\(applicationId)/reject"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchDetail:
            return .get
        case .allow, .reject:
            return .patch
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .reject(_, let request):
            guard let reason = request.rejectionReason, !reason.isBlank else { return nil }
            return ["rejectionReason": reason]
        case .fetchDetail, .allow:
            return nil
        }
    }
}
