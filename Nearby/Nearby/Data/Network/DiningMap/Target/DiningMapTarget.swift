//
//  DiningMapTarget.swift
//  Nearby
//
//  Created by soomin on 7/14/26.
//

import Alamofire

struct DiningListQuery {
    let latitude: Double
    let longitude: Double
    let category: String?
}

struct DiningDetailQuery {
    let placeId: Int
    let latitude: Double
    let longitude: Double
}

enum DiningMapTarget {
    case list(DiningListQuery)
    case detail(DiningDetailQuery)
}

extension DiningMapTarget: BaseTargetType {
    var path: String {
        switch self {
        case .list:
            return "/api/solo-dining/places"
        case .detail(let query):
            return "/api/solo-dining/places/\(query.placeId)"
        }
    }

    var method: HTTPMethod { .get }

    var queryParameters: Parameters? {
        switch self {
        case .list(let query):
            var parameters: Parameters = [
                "latitude": query.latitude,
                "longitude": query.longitude
            ]
            if let category = query.category {
                parameters["category"] = category
            }
            return parameters
        case .detail(let query):
            return [
                "latitude": query.latitude,
                "longitude": query.longitude
            ]
        }
    }
}
