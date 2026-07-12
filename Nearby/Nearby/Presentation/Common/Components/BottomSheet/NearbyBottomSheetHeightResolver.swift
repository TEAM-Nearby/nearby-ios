//
//  NearbyBottomSheetHeightResolver.swift
//  Nearby
//
//  Created by soomin on 7/10/26.
//

import UIKit

struct NearbyBottomSheetHeightContext {
    let availableHeight: CGFloat
    let topSafeAreaInset: CGFloat
    let tabBarHeight: CGFloat
}

enum NearbyBottomSheetHeightResolver {
    static func height(for state: BottomSheetState, context: NearbyBottomSheetHeightContext) -> CGFloat {
        switch state.level {
        case .compact:
            return compactHeight(for: state.content, context: context)
        case .standard:
            return standardHeight(for: state.content, context: context)
        case .expanded:
            return expandedHeight(for: state.content, context: context)
        }
    }
    
    private static func compactHeight(for content: BottomSheetContent, context: NearbyBottomSheetHeightContext) -> CGFloat {
        switch content {
        case .nearbyCompanionList:
            return NearbyBottomSheetValue.nearCompanionCompactHeight + context.tabBarHeight
        case .specificRestaurantCompanionList:
            return NearbyBottomSheetValue.specificCompanionCompactHeight
        case .diningMapList:
            return NearbyBottomSheetValue.diningListCompactHeight + context.tabBarHeight
        case .savedRestaurantList:
            return NearbyBottomSheetValue.savedDiningListCompactHeight
        case .diningInfo:
            return NearbyBottomSheetValue.diningInfoSummaryHeight
        case .nearbyCompanionEmpty:
            return NearbyBottomSheetValue.nearbyCompanionEmptyCompactHeight
        }
    }
    
    private static func standardHeight(for content: BottomSheetContent, context: NearbyBottomSheetHeightContext) -> CGFloat {
        switch content {
        case .nearbyCompanionEmpty:
            return NearbyBottomSheetValue.nearbyCompanionEmptyStandardHeight + context.tabBarHeight
        case .specificRestaurantCompanionList:
            return companionListStandardHeight(context: context) + NearbyBottomSheetValue.companionListStandardHeightAddition
        case .nearbyCompanionList:
            return max(0, companionListStandardHeight(context: context) + NearbyBottomSheetValue.companionListStandardHeightAddition)
        case .diningMapList:
            return NearbyBottomSheetValue.diningListStandardHeight
        case .savedRestaurantList:
            return NearbyBottomSheetValue.savedDiningListStandardHeight
        case .diningInfo:
            return NearbyBottomSheetValue.diningInfoSummaryHeight
        }
    }
    
    private static func expandedHeight(for content: BottomSheetContent, context: NearbyBottomSheetHeightContext) -> CGFloat {
        let baseHeight = max(
            0,
            context.availableHeight - context.topSafeAreaInset - NearbyBottomSheetValue.expandedTopSpacing
        )
        
        switch content {
        case .specificRestaurantCompanionList:
            return max(0, baseHeight - NearbyBottomSheetValue.specificCompanionExpandedHeightReduction)
        case .diningInfo:
            return NearbyBottomSheetValue.diningInfoExpandedHeight
        case .nearbyCompanionList, .nearbyCompanionEmpty, .diningMapList, .savedRestaurantList:
            return baseHeight
        }
    }
    
    private static func companionListStandardHeight(context: NearbyBottomSheetHeightContext) -> CGFloat {
        let compactDeviceReduction = max(0, NearbyBottomSheetValue.companionListCompactDeviceReferenceHeight - context.availableHeight) * 0.45
        
        return max(
            NearbyBottomSheetValue.companionListMinimumStandardHeight,
            NearbyBottomSheetValue.companionListStandardHeight - compactDeviceReduction
        )
    }
}
