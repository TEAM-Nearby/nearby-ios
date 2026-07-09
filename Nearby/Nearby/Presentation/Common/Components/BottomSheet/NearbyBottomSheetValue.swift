//
//  NearbyBottomSheetValue.swift
//  Nearby
//
//  Created by soomin on 7/10/26.
//

import UIKit

enum NearbyBottomSheetValue {
    static let contentTopOffset: CGFloat = 24
    
    static let nearCompanionCompactHeight = contentTopOffset + nearCompanionTitleTopOffset + nearCompanionTitleHeight
                                            + nearCompanionSortTopOffset + nearCompanionSortButtonHeight + nearCompanionCollectionTopOffset
                                            + nearCompanionDividerHeight + nearCompanionDividerBottomSpacing
    
    static let specificCompanionCompactHeight = contentTopOffset + specificCompanionTitleTopOffset + specificCompanionTitleHeight
                                                + specificCompanionImageTopOffset + specificCompanionImageHeight
    
    static let nearCompanionTitleTopOffset: CGFloat = 8
    static let nearCompanionTitleHeight: CGFloat = NearbyFont.h3Sb20.property.lineHeight
    static let nearCompanionSortTopOffset: CGFloat = 12
    static let nearCompanionSortButtonHeight: CGFloat = NearbyChipStyle.filterSortUnselected.height
    static let nearCompanionCollectionTopOffset: CGFloat = 12
    static let nearCompanionDividerHeight: CGFloat = 1
    static let nearCompanionDividerBottomSpacing: CGFloat = 6
    
    static let specificCompanionTitleTopOffset: CGFloat = 14
    static let specificCompanionTitleHeight: CGFloat = NearbyFont.h3Sb20.property.lineHeight
    static let specificCompanionImageTopOffset: CGFloat = 14
    static let specificCompanionImageHeight: CGFloat = 150
    
    static let expandedTopSpacing: CGFloat = 48
    static let specificCompanionExpandedHeightReduction: CGFloat = 16
    static let companionListStandardHeight: CGFloat = 383
    static let companionListStandardHeightAddition: CGFloat = 20
    static let companionListCompactDeviceReferenceHeight: CGFloat = 852
    static let companionListMinimumStandardHeight: CGFloat = 360
}
