//
//  BaseTargetType.swift
//  Nearby
//
//  Created by soomin on 7/5/26.
//

import Alamofire
import Foundation

protocol BaseTargetType {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var queryParameters: Parameters? { get }
    var bodyParameters: Parameters? { get }
    var requiresAuth: Bool { get }
}

extension BaseTargetType {
    var headers: HTTPHeaders {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    var queryParameters: Parameters? {
        nil
    }

    var bodyParameters: Parameters? {
        nil
    }

    var requiresAuth: Bool {
        true
    }

    func makeHeaders(accessToken: String?) -> HTTPHeaders {
        var headers = headers

        if requiresAuth, let accessToken, !accessToken.isEmpty {
            headers.add(.authorization(bearerToken: accessToken))
        }

        return headers
    }
}
