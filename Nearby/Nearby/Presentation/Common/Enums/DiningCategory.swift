//
//  DiningCategory.swift
//  Nearby
//
//  Created by soomin on 7/11/26.
//

import UIKit

enum DiningCategory: CaseIterable, Hashable {
    case restaurant
    case cafe
    case bar
    case dessert
    case paella

    // MARK: - Properties
    
    var title: String {
        switch self {
        case .restaurant:
            "식당"
        case .cafe:
            "카페"
        case .bar:
            "바"
        case .dessert:
            "디저트 가게"
        case .paella:
            "빠에야 전문"
        }
    }

    var icon: UIImage {
        switch self {
        case .restaurant:
            return .icChinese
        case .cafe:
            return .icCafe
        case .bar:
            return .icBar
        case .dessert:
            return .icCake
        case .paella:
            return .icRestaurant
        }
    }
}
