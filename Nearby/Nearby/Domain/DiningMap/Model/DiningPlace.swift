//
//  DiningPlace.swift
//  Nearby
//
//  Created by soomin on 9/22/26.
//

import Foundation

struct DiningPlace {
    let placeId: Int
    let googlePlaceId: String
    let name: String
    let address: String?
    let imageURL: URL?
    let category: Category
    let businessStatus: BusinessStatus
    let distanceMeters: Int
    let rating: Double?
    let reviewCount: Int?
    let isFavorite: Bool
    let latitude: Double?
    let longitude: Double?
    let phoneNumber: String?
    let regularOpeningHours: [String]
    let editorialSummary: String?
    let priceRange: String?
}

extension DiningPlace {
    enum Category: Equatable {
        case restaurant
        case cafe
        case pub
        case other
        case unknown(String?)
    }

    enum BusinessStatus: Equatable {
        case operational
        case closedTemporarily
        case closedPermanently
        case unknown(String)
    }
}

struct DiningFavoriteList {
    let totalCount: Int
    let places: [DiningPlace]
}

struct DiningPlaceSearchCriteria {
    let latitude: Double
    let longitude: Double
    let category: DiningPlace.Category
}

struct DiningPlaceDetailCriteria {
    let placeId: Int
    let latitude: Double
    let longitude: Double
}

struct DiningFavoritesCriteria {
    let latitude: Double
    let longitude: Double
    let category: DiningPlace.Category
    let sort: DiningFavoriteSort
}

enum DiningFavoriteSort {
    case latest
    case oldest
}
