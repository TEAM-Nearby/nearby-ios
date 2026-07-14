//
//  NearDiningCellItem.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import UIKit

struct NearDiningCellItem {
    
    // MARK: - Properties
    
    let placeId: Int?
    let googlePlaceId: String?
    let name: String
    let category: String
    let businessStatus: String
    let distance: String
    let address: String
    let rating: Double
    let reviewCount: Int
    let images: [UIImage?]
    var isBookmarked: Bool
    let latitude: Double?
    let longitude: Double?
    let description: String
    let closingTime: String
    let phoneNumber: String
    let price: String

    init(
        placeId: Int? = nil,
        googlePlaceId: String? = nil,
        name: String,
        category: String,
        businessStatus: String,
        distance: String,
        address: String,
        rating: Double,
        reviewCount: Int,
        images: [UIImage?],
        isBookmarked: Bool,
        latitude: Double? = nil,
        longitude: Double? = nil,
        description: String = "",
        closingTime: String = "",
        phoneNumber: String = "",
        price: String = ""
    ) {
        self.placeId = placeId
        self.googlePlaceId = googlePlaceId
        self.name = name
        self.category = category
        self.businessStatus = businessStatus
        self.distance = distance
        self.address = address
        self.rating = rating
        self.reviewCount = reviewCount
        self.images = images
        self.isBookmarked = isBookmarked
        self.latitude = latitude
        self.longitude = longitude
        self.description = description
        self.closingTime = closingTime
        self.phoneNumber = phoneNumber
        self.price = price
    }
}

extension NearDiningCellItem {
    init(dto: DiningPlaceDTO) {
        self.init(
            placeId: dto.placeId,
            googlePlaceId: dto.googlePlaceId,
            name: dto.name,
            category: dto.category?.diningCategoryTitle ?? "식당",
            businessStatus: dto.businessStatus.diningBusinessStatusTitle,
            distance: dto.distanceMeters.diningDistanceText,
            address: dto.address ?? "",
            rating: dto.rating ?? 0,
            reviewCount: dto.reviewCount ?? 0,
            images: [.restaurantPlaceholder],
            isBookmarked: dto.isFavorite,
            latitude: dto.latitude,
            longitude: dto.longitude
        )
    }

    init(dto: DiningDetailResponseDTO) {
        let photoCount = max(dto.photoReferences?.count ?? 0, dto.photoReference == nil ? 0 : 1)

        self.init(
            placeId: dto.placeId,
            googlePlaceId: dto.googlePlaceId,
            name: dto.name,
            category: dto.category?.diningCategoryTitle ?? "식당",
            businessStatus: dto.businessStatus.diningBusinessStatusTitle,
            distance: dto.distanceMeters.diningDistanceText,
            address: dto.address ?? "",
            rating: dto.rating ?? 0,
            reviewCount: dto.reviewCount ?? 0,
            images: Array(repeating: .restaurantPlaceholder, count: max(photoCount, 1)),
            isBookmarked: dto.isFavorite,
            latitude: dto.latitude,
            longitude: dto.longitude,
            description: dto.editorialSummary ?? "",
            closingTime: dto.regularOpeningHours?.first ?? "",
            phoneNumber: dto.phoneNumber ?? "",
            price: dto.priceRange ?? ""
        )
    }
}

private extension String {
    var diningCategoryTitle: String {
        switch self {
        case "RESTAURANT": "식당"
        case "CAFE": "카페"
        case "PUB": "바"
        case "OTHER": "빠에야 전문"
        default: self
        }
    }

    var diningBusinessStatusTitle: String {
        switch self {
        case "OPERATIONAL": "영업중"
        case "CLOSED_TEMPORARILY": "임시 휴업"
        case "CLOSED_PERMANENTLY": "폐업"
        default: self
        }
    }
}

private extension Int {
    var diningDistanceText: String {
        guard self >= 1_000 else { return "\(self)m" }
        return String(format: "%.1fkm", Double(self) / 1_000)
    }
}
