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
    let imageURLs: [URL?]
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
        imageURLs: [URL?] = [],
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
        self.imageURLs = imageURLs
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
    init(dto: DiningFavoritePlaceDTO) {
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
            imageURLs: [dto.imageUrl.flatMap(URL.init(string:))],
            isBookmarked: dto.isFavorite
        )
    }

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
            imageURLs: [dto.imageUrl.flatMap(URL.init(string:))],
            isBookmarked: dto.isFavorite,
            latitude: dto.latitude,
            longitude: dto.longitude
        )
    }

    init(dto: DiningDetailResponseDTO) {
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
            imageURLs: [dto.imageUrl.flatMap(URL.init(string:))],
            isBookmarked: dto.isFavorite,
            latitude: dto.latitude,
            longitude: dto.longitude,
            description: dto.editorialSummary ?? "",
            closingTime: dto.regularOpeningHours?.first ?? "",
            phoneNumber: dto.phoneNumber ?? "",
            price: dto.priceRange?.diningPriceRangeText ?? ""
        )
    }
}

private extension String {
    var diningPriceRangeText: String {
        let currencySymbols = [
            "EUR": "€",
            "USD": "$",
            "KRW": "₩",
            "GBP": "£",
            "JPY": "¥",
            "CNY": "¥"
        ]
        var result = trimmingCharacters(in: .whitespacesAndNewlines)

        currencySymbols.forEach { code, symbol in
            result = result.replacingOccurrences(
                of: code,
                with: symbol,
                options: .caseInsensitive
            )

            while result.contains("\(symbol) ") {
                result = result.replacingOccurrences(of: "\(symbol) ", with: symbol)
            }
        }

        result = result.replacingOccurrences(
            of: #"\s*([~\-–—])\s*"#,
            with: "$1",
            options: .regularExpression
        )

        if let symbol = currencySymbols.values.first(where: { result.hasPrefix($0) }) {
            let rangeWithoutLeadingSymbol = String(result.dropFirst(symbol.count))
                .replacingOccurrences(of: symbol, with: "")
            result = symbol + rangeWithoutLeadingSymbol
        }

        return result
    }

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
