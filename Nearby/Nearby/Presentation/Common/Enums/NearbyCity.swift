//
//  NearbyCity.swift
//  Nearby
//
//  Created by h2e on 10/29/26.
//

enum NearbyCity: String {
    case barcelona = "BARCELONA"
    case madrid = "MADRID"
    case london = "LONDON"
    case paris = "PARIS"

    var koreanName: String {
        switch self {
        case .barcelona:
            return "바르셀로나"
        case .madrid:
            return "마드리드"
        case .london:
            return "런던"
        case .paris:
            return "파리"
        }
    }

    static func koreanName(for code: String?) -> String? {
        code.flatMap(NearbyCity.init(rawValue:))?.koreanName
    }
}
