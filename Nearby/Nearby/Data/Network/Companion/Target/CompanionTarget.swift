//
//  CompanionTarget.swift
//  Nearby
//
//  Created by soomin on 7/13/26.
//

import Alamofire

struct CompanionListQuery {
    let latitude: Double
    let longitude: Double
    let radiusMeters: Int
    let placeCategory: String
    let sort: String
}

enum CompanionTarget {
    case list(CompanionListQuery)
}

extension CompanionTarget: BaseTargetType {
    var path: String { "/api/companion-posts" }

    var method: HTTPMethod { .get }

    var queryParameters: Parameters? {
        switch self {
        case .list(let query):
            return [
                "latitude": query.latitude,
                "longitude": query.longitude,
                "radiusMeters": query.radiusMeters,
                "placeCategory": query.placeCategory,
                "sort": query.sort
            ]
        }
    }
}
