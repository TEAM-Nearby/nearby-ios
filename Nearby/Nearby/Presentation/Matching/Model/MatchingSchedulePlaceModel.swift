//
//  MatchingSchedulePlaceModel.swift
//  Nearby
//
//  Created by 장지인 on 7/12/26.
//

import Foundation

struct MatchingSchedulePlaceModel: Decodable {
    let googlePlaceId: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
}
