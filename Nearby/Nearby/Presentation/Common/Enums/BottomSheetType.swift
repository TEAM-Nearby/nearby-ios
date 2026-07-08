//
//  BottomSheetType.swift
//  Nearby
//
//  Created by soomin on 7/7/26.
//

import UIKit

enum BottomSheetType {
    case nearbyCompanionSmall
    case nearbyCompanionMedium
    case nearbyCompanionBig
    case companionEmpty
    case specificCompanion
    case diningMap
    
    var isNearbyCompanion: Bool {
        switch self {
        case .nearbyCompanionSmall, .nearbyCompanionMedium, .nearbyCompanionBig:
            return true
        case .companionEmpty, .specificCompanion, .diningMap:
            return false
        }
    }
    
    var height: CGFloat {
        switch self {
        case .nearbyCompanionSmall:
            return 122
        case .nearbyCompanionMedium:
            return 383
        case .nearbyCompanionBig:
            return 667
        case .companionEmpty:
            return 297
        case .specificCompanion:
            return 517
        case .diningMap:
            return 423
        }
    }
}
