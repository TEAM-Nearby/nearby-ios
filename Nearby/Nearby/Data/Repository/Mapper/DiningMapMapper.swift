//
//  DiningMapMapper.swift
//  Nearby
//
//  Created by soomin on 9/22/26.
//

import Foundation

enum DiningMapMapper {
    static func map(_ dto: DiningPlaceDTO) -> DiningPlace {
        DiningPlace(
            placeId: dto.placeId,
            googlePlaceId: dto.googlePlaceId,
            name: dto.name,
            address: dto.address,
            imageURL: dto.imageUrl.flatMap(URL.init(string:)),
            category: mapCategory(dto.category),
            businessStatus: mapBusinessStatus(dto.businessStatus),
            distanceMeters: dto.distanceMeters,
            rating: dto.rating,
            reviewCount: dto.reviewCount,
            isFavorite: dto.isFavorite,
            latitude: dto.latitude,
            longitude: dto.longitude,
            phoneNumber: nil,
            regularOpeningHours: [],
            editorialSummary: nil,
            priceRange: nil
        )
    }

    static func map(_ dto: DiningFavoritePlaceDTO) -> DiningPlace {
        DiningPlace(
            placeId: dto.placeId,
            googlePlaceId: dto.googlePlaceId,
            name: dto.name,
            address: dto.address,
            imageURL: dto.imageUrl.flatMap(URL.init(string:)),
            category: mapCategory(dto.category),
            businessStatus: mapBusinessStatus(dto.businessStatus),
            distanceMeters: dto.distanceMeters,
            rating: dto.rating,
            reviewCount: dto.reviewCount,
            isFavorite: dto.isFavorite,
            latitude: nil,
            longitude: nil,
            phoneNumber: nil,
            regularOpeningHours: [],
            editorialSummary: nil,
            priceRange: nil
        )
    }

    static func map(_ dto: DiningDetailResponseDTO) -> DiningPlace {
        DiningPlace(
            placeId: dto.placeId,
            googlePlaceId: dto.googlePlaceId,
            name: dto.name,
            address: dto.address,
            imageURL: dto.imageUrl.flatMap(URL.init(string:)),
            category: mapCategory(dto.category),
            businessStatus: mapBusinessStatus(dto.businessStatus),
            distanceMeters: dto.distanceMeters,
            rating: dto.rating,
            reviewCount: dto.reviewCount,
            isFavorite: dto.isFavorite,
            latitude: dto.latitude,
            longitude: dto.longitude,
            phoneNumber: dto.phoneNumber,
            regularOpeningHours: dto.regularOpeningHours ?? [],
            editorialSummary: dto.editorialSummary,
            priceRange: dto.priceRange
        )
    }

    static func map(_ criteria: DiningPlaceSearchCriteria) -> DiningListQuery {
        DiningListQuery(latitude: criteria.latitude, longitude: criteria.longitude,
                        category: serverKey(for: criteria.category))
    }

    static func map(_ criteria: DiningPlaceDetailCriteria) -> DiningDetailQuery {
        DiningDetailQuery(placeId: criteria.placeId, latitude: criteria.latitude, longitude: criteria.longitude)
    }

    static func map(_ criteria: DiningFavoritesCriteria) -> DiningFavoritesQuery {
        DiningFavoritesQuery(latitude: criteria.latitude, longitude: criteria.longitude,
                             category: serverKey(for: criteria.category), sort: serverKey(for: criteria.sort))
    }

    private static func mapCategory(_ rawValue: String?) -> DiningPlace.Category {
        switch rawValue {
        case "RESTAURANT":
            return .restaurant
        case "CAFE":
            return .cafe
        case "PUB":
            return .pub
        case "OTHER":
            return .other
        default:
            return .unknown(rawValue)
        }
    }

    private static func mapBusinessStatus(_ rawValue: String) -> DiningPlace.BusinessStatus {
        switch rawValue {
        case "OPERATIONAL":
            return .operational
        case "CLOSED_TEMPORARILY":
            return .closedTemporarily
        case "CLOSED_PERMANENTLY":
            return .closedPermanently
        default:
            return .unknown(rawValue)
        }
    }

    private static func serverKey(for category: DiningPlace.Category) -> String? {
        switch category {
        case .restaurant:
            return "RESTAURANT"
        case .cafe:
            return "CAFE"
        case .pub:
            return "PUB"
        case .other:
            return "OTHER"
        case .unknown(let rawValue):
            return rawValue
        }
    }

    private static func serverKey(for sort: DiningFavoriteSort) -> String {
        switch sort {
        case .latest:
            return "LATEST"
        case .oldest:
            return "OLDEST"
        }
    }
}
