//
//  NearbyBottomSheetValue.swift
//  Nearby
//
//  Created by soomin on 7/10/26.
//

import UIKit

enum NearbyBottomSheetValue {
    static let contentTopOffset: CGFloat = 24
    static let nearbyCompanionEmptyCompactHeight: CGFloat = 122
    static let nearbyCompanionEmptyStandardHeight: CGFloat = 297
    static let diningListStandardHeight: CGFloat = 403
    static let diningInfoSummaryHeight: CGFloat = 158
    static let diningInfoExpandedHeight: CGFloat = 520

    static let savedDiningListCompactHeight = contentTopOffset + savedDiningTitleTopOffset + savedDiningTitleHeight
                                              + diningCategoryTopOffset + diningCategoryHeight
                                              + savedDiningCollectionTopOffset + savedDiningCellTextHeight
                                              + savedDiningImagePeekHeight + savedDiningCollectionBottomInset

    static let savedDiningListStandardHeight = contentTopOffset + savedDiningTitleTopOffset + savedDiningTitleHeight
                                               + diningCategoryTopOffset + diningCategoryHeight
                                               + savedDiningCollectionTopOffset + savedDiningCellHeight
                                               + savedDiningCollectionBottomInset + savedDiningDividerBottomSpacing

    static let diningListCompactHeight = contentTopOffset + diningTitleTopOffset + diningTitleHeight
                                         + diningCategoryTopOffset + diningCategoryHeight
                                         + diningCategoryBottomSpacing
    
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

    static let diningTitleTopOffset: CGFloat = 8
    static let diningTitleHeight: CGFloat = NearbyFont.h3Sb20.property.lineHeight * 2
    static let diningCategoryTopOffset: CGFloat = 12
    static let diningCategoryHeight: CGFloat = NearbyChipStyle.diningCategorySelected.height
    static let diningCategoryBottomSpacing: CGFloat = 12

    static let savedDiningTitleTopOffset: CGFloat = 8
    static let savedDiningTitleHeight: CGFloat = NearbyFont.h3Sb20.property.lineHeight
    static let savedDiningCollectionTopOffset: CGFloat = 20
    static let savedDiningCellTextHeight: CGFloat = NearbyFont.b1Sb18.property.lineHeight + 4
                                                    + NearbyFont.b3R14.property.lineHeight + 8
    static let savedDiningImagePeekHeight: CGFloat = 42
    static let savedDiningCellHeight: CGFloat = 245
    static let savedDiningCollectionBottomInset: CGFloat = 0
    static let savedDiningDividerBottomSpacing: CGFloat = 2
    
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
