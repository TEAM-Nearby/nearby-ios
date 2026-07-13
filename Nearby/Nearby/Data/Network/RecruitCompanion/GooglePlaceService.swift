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

    func refreshSessionToken() {
        sessionToken = GMSAutocompleteSessionToken()
    }
}
