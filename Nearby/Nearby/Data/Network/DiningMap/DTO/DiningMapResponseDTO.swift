//
//  DiningMapResponseDTO.swift
//  Nearby
//
//  Created by soomin on 7/14/26.
//

struct DiningListResponseDTO: Decodable {
    let places: [DiningPlaceDTO]
}

struct DiningPlaceDTO: Decodable {
    let placeId: Int
    let googlePlaceId: String
    let name: String
    let address: String?
    let photoReference: String?
    let category: String?
    let distanceMeters: Int
    let rating: Double?
    let reviewCount: Int?
    let isFavorite: Bool
    let latitude: Double
    let longitude: Double
    let businessStatus: String
}

struct DiningDetailResponseDTO: Decodable {
    let placeId: Int
    let googlePlaceId: String
    let name: String
    let address: String?
    let latitude: Double
    let longitude: Double
    let category: String?
    let distanceMeters: Int
    let rating: Double?
    let reviewCount: Int?
    let phoneNumber: String?
    let photoReference: String?
    let photoReferences: [String]?
    let businessStatus: String
    let priceLevel: String?
    let priceRange: String?
    let regularOpeningHours: [String]?
    let editorialSummary: String?
    let isFavorite: Bool
}
