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

    init(place: DiningPlace) {
        self.init(
            placeId: place.placeId,
            googlePlaceId: place.googlePlaceId,
            name: place.name,
            category: Self.categoryTitle(for: place.category),
            businessStatus: Self.businessStatusTitle(for: place.businessStatus),
            distance: Self.distanceText(for: place.distanceMeters),
            address: place.address ?? "",
            rating: place.rating ?? 0,
            reviewCount: place.reviewCount ?? 0,
            images: [nil],
            imageURLs: [place.imageURL],
            isBookmarked: place.isFavorite,
            latitude: place.latitude,
            longitude: place.longitude,
            description: place.editorialSummary ?? "",
            closingTime: place.regularOpeningHours.first ?? "",
            phoneNumber: place.phoneNumber ?? "",
            price: Self.priceRangeText(place.priceRange)
        )
    }

    private static func categoryTitle(for category: DiningPlace.Category) -> String {
        switch category {
        case .restaurant:
            return "식당"
        case .cafe:
            return "카페"
        case .pub:
            return "바"
        case .other:
            return "빠에야 전문"
        case .unknown(let rawValue):
            return rawValue ?? "식당"
        }
    }

    private static func businessStatusTitle(for status: DiningPlace.BusinessStatus) -> String {
        switch status {
        case .operational:
            return "영업중"
        case .closedTemporarily:
            return "임시 휴업"
        case .closedPermanently:
            return "폐업"
        case .unknown(let rawValue):
            return rawValue
        }
    }

    private static func distanceText(for distanceMeters: Int) -> String {
        guard distanceMeters >= 1_000 else { return "\(distanceMeters)m" }
        return String(format: "%.1fkm", Double(distanceMeters) / 1_000)
    }

    private static func priceRangeText(_ priceRange: String?) -> String {
        guard let priceRange else { return "" }
        let currencySymbols = [
            "EUR": "€",
            "USD": "$",
            "KRW": "₩",
            "GBP": "£",
            "JPY": "¥",
            "CNY": "¥"
        ]
        var result = priceRange.trimmingCharacters(in: .whitespacesAndNewlines)

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
}
