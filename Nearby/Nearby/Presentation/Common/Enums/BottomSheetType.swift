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
    case specificCompanionBig
    case diningMap
    case diningMapFullScreen

    var snapTypes: [BottomSheetType] {
        switch self {
        case .nearbyCompanionSmall, .nearbyCompanionMedium, .nearbyCompanionBig:
            return [.nearbyCompanionSmall, .nearbyCompanionMedium, .nearbyCompanionBig]
        case .specificCompanion, .specificCompanionBig:
            return [.specificCompanion, .specificCompanionBig]
        case .diningMap, .diningMapFullScreen:
            return [.diningMap, .diningMapFullScreen]
        case .companionEmpty:
            return []
        }
    }

    var isDraggable: Bool {
        !snapTypes.isEmpty
    }

    var smallType: BottomSheetType {
        switch self {
        case .nearbyCompanionSmall, .nearbyCompanionMedium, .nearbyCompanionBig:
            return .nearbyCompanionSmall
        case .specificCompanion, .specificCompanionBig:
            return .specificCompanion
        case .diningMap, .diningMapFullScreen:
            return .diningMap
        case .companionEmpty:
            return .companionEmpty
        }
    }

    var isSmallType: Bool {
        self == smallType
    }

    var isThirdStep: Bool {
        snapTypes.count == 3 && self == snapTypes.last
    }

    var fixedHeight: CGFloat? {
        switch self {
        case .nearbyCompanionSmall:
            return 122
        case .nearbyCompanionMedium:
            return 383
        case .companionEmpty:
            return 297
        case .specificCompanion:
            return 517
        case .diningMap:
            return 423
        case .nearbyCompanionBig, .specificCompanionBig, .diningMapFullScreen:
            return nil
        }
    }
}
