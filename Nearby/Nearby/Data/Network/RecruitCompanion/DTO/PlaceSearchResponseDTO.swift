//
//  PlaceSearchResponseDTO.swift
//  Nearby
//
//  Created by 장지인 on 10/9/26.
//

import Foundation

struct PlaceSearchResponseDTO: Decodable {
    let places: [Place]

    struct Place: Decodable {
        let googlePlaceId: String
        let name: String
        let address: String
        let latitude: Double
        let longitude: Double
        let category: String?
    }

    private enum CodingKeys: String, CodingKey {
        case places
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        places = try container.decodeIfPresent([Place].self, forKey: .places) ?? []
    }
}
