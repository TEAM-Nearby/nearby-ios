//
//  ApplicantCompanionTarget.swift
//  Nearby
//
//  Created by h2e on 7/13/26.
//

import Foundation
import Alamofire

enum ApplicantCompanionTarget {
    case fetchResult(applicationId: Int)
}

extension ApplicantCompanionTarget: BaseTargetType {
    var path: String {
        switch self {
        case .fetchResult(let applicationId):
            return "/api/users/me/companion-requests/\(applicationId)/result"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchResult:
            return .get
        }
    }
}
