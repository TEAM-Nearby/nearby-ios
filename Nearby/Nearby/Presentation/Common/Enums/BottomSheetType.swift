//
//  BottomSheetType.swift
//  Nearby
//
//  Created by soomin on 7/7/26.
//

import Foundation

enum BottomSheetContent {
    case nearbyCompanionList
    case nearbyCompanionEmpty
    case specificRestaurantCompanionList
    case diningMapList
    case savedRestaurantList
    case diningInfo

    var defaultLevel: BottomSheetLevel {
        switch self {
        case .diningInfo:
            return .expanded
        case .nearbyCompanionList, .nearbyCompanionEmpty,
             .specificRestaurantCompanionList, .diningMapList, .savedRestaurantList:
            return .standard
        }
    }

    var availableLevels: [BottomSheetLevel] {
        switch self {
        case .nearbyCompanionEmpty:
            return [.standard]
        case .diningInfo:
            return [.standard, .expanded]
        case .nearbyCompanionList,
             .specificRestaurantCompanionList,
             .diningMapList,
             .savedRestaurantList:
            return [.compact, .standard, .expanded]
        }
    }
}

enum BottomSheetLevel {
    case compact
    case standard
    case expanded
}

struct BottomSheetState: Equatable {
    let content: BottomSheetContent
    let level: BottomSheetLevel

    init(content: BottomSheetContent, level: BottomSheetLevel? = nil) {
        self.content = content
        self.level = level ?? content.defaultLevel
    }

    var availableLevels: [BottomSheetLevel] {
        content.availableLevels
    }

    var isDraggable: Bool {
        availableLevels.count > 1
    }

    var isFirstLevel: Bool {
        level == availableLevels.first
    }

    var isSecondLevel: Bool {
        level == .standard
    }

    var isThirdLevel: Bool {
        level == .expanded && availableLevels.contains(.expanded)
    }

    var compactState: BottomSheetState {
        BottomSheetState(content: content, level: availableLevels.first ?? level)
    }
}
