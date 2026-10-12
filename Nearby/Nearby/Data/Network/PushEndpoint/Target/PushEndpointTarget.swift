//
//  PushEndpointTarget.swift
//  Nearby
//
//  Created by h2e on 10/12/26.
//

import Foundation
import Alamofire

enum PushEndpointTarget {
    case register(request: RegisterPushEndpointRequestDTO)
    case unregister(installationId: String)
}

extension PushEndpointTarget: BaseTargetType {
    var path: String {
        switch self {
        case .register:
            return "/api/users/me/push-endpoints"
        case .unregister(let installationId):
            return "/api/users/me/push-endpoints/\(installationId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .register:
            return .post
        case .unregister:
            return .delete
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .register(let request):
            return [
                "installationId": request.installationId,
                "token": request.token,
                "platform": request.platform
            ]
        case .unregister:
            return nil
        }
    }
}
