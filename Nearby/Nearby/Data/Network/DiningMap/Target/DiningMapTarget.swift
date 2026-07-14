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

struct DiningFavoritesQuery {
    let latitude: Double
    let longitude: Double
    let category: String?
    let sort: String?
}

enum DiningMapTarget {
    case list(DiningListQuery)
    case detail(DiningDetailQuery)
    case favorites(DiningFavoritesQuery)
    case registerFavorite(placeId: Int)
    case removeFavorite(placeId: Int)
}

extension DiningMapTarget: BaseTargetType {
    var path: String {
        switch self {
        case .list:
            return "/api/solo-dining/places"
        case .detail(let query):
            return "/api/solo-dining/places/\(query.placeId)"
        case .favorites:
            return "/api/solo-dining/favorites"
        case .registerFavorite(let placeId), .removeFavorite(let placeId):
            return "/api/solo-dining/places/\(placeId)/favorite"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list, .detail, .favorites:
            return .get
        case .registerFavorite:
            return .put
        case .removeFavorite:
            return .delete
        }
    }

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
        case .favorites(let query):
            var parameters: Parameters = [
                "latitude": query.latitude,
                "longitude": query.longitude
            ]
            if let category = query.category {
                parameters["category"] = category
            }
            if let sort = query.sort {
                parameters["sort"] = sort
            }
            return parameters
        case .registerFavorite, .removeFavorite:
            return nil
        }
    }
}
