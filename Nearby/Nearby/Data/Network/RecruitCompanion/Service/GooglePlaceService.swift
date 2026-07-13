//
//  GooglePlaceService.swift
//  Nearby
//
//  Created by 장지인 on 7/13/26.
//

import CoreLocation
import Foundation

import GooglePlaces

final class GooglePlaceService {

    // MARK: - Properties

    private let placesClient = GMSPlacesClient.shared()
    private var sessionToken = GMSAutocompleteSessionToken()

    // MARK: - Methods

    func searchPlaces(query: String, latitude: Double, longitude: Double, completion: @escaping (Result<[PlaceSearchResultItem], Error>) -> Void) {
        let trimmedQuery = query.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedQuery.isEmpty else {
            completion(.success([]))
            return
        }

        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        let filter = GMSAutocompleteFilter()
        filter.origin = CLLocation(latitude: latitude, longitude: longitude)
        filter.locationBias = GMSPlaceCircularLocationOption(coordinate, 30_000)
        filter.regionCode = "ES"

        let request = GMSAutocompleteRequest(query: trimmedQuery)

        request.sessionToken = sessionToken
        request.filter = filter

        placesClient.fetchAutocompleteSuggestions(from: request) { suggestions, error in
            if let error {
                completion(.failure(error))
                return
            }

            let items = suggestions?
                .compactMap(\.placeSuggestion)
                .map {
                    PlaceSearchResultItem(
                        placeID: $0.placeID,
                        name: $0.attributedPrimaryText.string,
                        address: $0.attributedSecondaryText?.string ?? ""
                    )
                } ?? []

            completion(.success(items))
        }
    }

    func fetchPlaceDetail(for item: PlaceSearchResultItem, completion: @escaping (Result<SelectedPlace, Error>) -> Void) {
        let placeProperties: [String] = [
            GMSPlaceProperty.name.rawValue,
            GMSPlaceProperty.formattedAddress.rawValue,
            GMSPlaceProperty.coordinate.rawValue,
            GMSPlaceProperty.types.rawValue
        ]
        let request = GMSFetchPlaceRequest(
            placeID: item.placeID,
            placeProperties: placeProperties,
            sessionToken: sessionToken
        )

        placesClient.fetchPlace(with: request) { [weak self] place, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let place else {
                completion(.failure(GooglePlaceServiceError.placeNotFound))
                return
            }

            let selectedPlace = SelectedPlace(
                placeID: item.placeID,
                name: place.name ?? item.name,
                address: place.formattedAddress ?? item.address,
                latitude: place.coordinate.latitude,
                longitude: place.coordinate.longitude,
                category: self?.category(from: place.types ?? []) ?? .other
            )

            completion(.success(selectedPlace))
        }
    }

    func refreshSessionToken() {
        sessionToken = GMSAutocompleteSessionToken()
    }

    private func category(from types: [String]) -> PlaceCategory {
        if types.contains(where: { $0 == "restaurant" || $0 == "food" || $0 == "meal_takeaway" }) {
            return .restaurant
        }
        if types.contains(where: { $0 == "cafe" || $0 == "coffee_shop" || $0 == "bakery" }) {
            return .cafe
        }
        if types.contains(where: { $0 == "bar" || $0 == "night_club" }) {
            return .pub
        }
        if types.contains(where: { $0 == "museum" || $0 == "art_gallery" }) {
            return .museum
        }
        if types.contains(where: { $0 == "tourist_attraction" || $0 == "landmark" }) {
            return .photoSpot
        }
        return .other
    }
}

private enum GooglePlaceServiceError: Error {
    case placeNotFound
}
