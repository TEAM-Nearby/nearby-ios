//
//  NearbyChipStyle.swift
//  Nearby
//
//  Created by 장지인 on 7/4/26.
//

import UIKit

enum NearbyChipStyle: Equatable {
    case personalityDefault
    case personalityOrange
    case category
    case companionCategorySelected
    case companionCategoryUnselected
    case categoryHonbapSelected
    case categoryHonbapUnselected
    case diningCategorySelected
    case diningCategoryUnselected
    case filterSortSelected
    case filterSortUnselected
    case tagStateSelected
    case tagStateUnselected
    case mapInfo
    case badgeVerification
    case badgeProfile
    
    var backgroundColor: UIColor {
        switch self {
        case .personalityDefault, .category, .companionCategoryUnselected, .diningCategoryUnselected,
                .filterSortUnselected, .tagStateUnselected, .mapInfo:
            return .white
        case .companionCategorySelected:
            return .primary40
        case .personalityOrange:
            return .chipPersonalityBgOrange
        case .categoryHonbapSelected, .diningCategorySelected,
                .filterSortSelected, .tagStateSelected:
            return .chipBgPurple
        case .categoryHonbapUnselected, .badgeProfile:
            return .chipBgGrey
        case .badgeVerification:
            return .bgDefaultGrey
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .personalityDefault, .filterSortUnselected, .tagStateUnselected:
            return .grey50
        case .personalityOrange:
            return .chipPersonalityTextOrange
        case .category, .companionCategoryUnselected:
            return .grey90
        case .companionCategorySelected:
            return .white
        case .categoryHonbapUnselected, .diningCategoryUnselected, .badgeProfile:
            return .grey40
        case .categoryHonbapSelected, .diningCategorySelected, .tagStateSelected:
            return .primary50
        case .filterSortSelected:
            return .highlightTextPurple
        case .mapInfo:
            return .grey80
        case .badgeVerification:
            return .grey70
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .personalityDefault, .categoryHonbapUnselected,
                .diningCategoryUnselected, .tagStateUnselected:
            return .grey10
        case .filterSortUnselected:
            return .chipBorderGrey
        case .personalityOrange, .category, .companionCategorySelected,
                .companionCategoryUnselected, .categoryHonbapSelected,
                .diningCategorySelected,
                .tagStateSelected, .mapInfo, .badgeProfile,
                .badgeVerification, .filterSortSelected:
            return .clear
        }
    }
    
    var font: UIFont {
        switch self {
        case .personalityOrange, .personalityDefault, .category,
                .companionCategorySelected, .companionCategoryUnselected,
                .categoryHonbapUnselected, .tagStateSelected,
                .tagStateUnselected, .filterSortUnselected,
                .diningCategoryUnselected:
            return NearbyFont.b3M14.font
        case .categoryHonbapSelected, .diningCategorySelected, .filterSortSelected:
            return NearbyFont.b3Sb14.font
        case .mapInfo:
            return NearbyFont.c1Sb12.font
        case .badgeVerification:
            return NearbyFont.c1M12.font
        case .badgeProfile:
            return NearbyFont.c1R12.font
        }
    }
    
    var height: CGFloat {
        switch self {
        case .personalityDefault, .personalityOrange,
                .tagStateSelected, .tagStateUnselected:
            return 36
        case .diningCategorySelected, .diningCategoryUnselected:
            return 34
        case .category, .companionCategorySelected, .companionCategoryUnselected,
                .categoryHonbapSelected, .categoryHonbapUnselected,
                .filterSortSelected, .filterSortUnselected:
            return 32
        case .mapInfo:
            return 37
        case .badgeVerification:
            return 29
        case .badgeProfile:
            return 21
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .personalityDefault, .personalityOrange,
                .category, .companionCategorySelected, .companionCategoryUnselected,
                .categoryHonbapSelected, .categoryHonbapUnselected,
                .diningCategorySelected, .diningCategoryUnselected,
                .filterSortSelected, .filterSortUnselected:
            return 30
        case .tagStateSelected, .tagStateUnselected:
            return 12
        case .mapInfo:
            return 99
        case .badgeVerification:
            return 15.18
        case .badgeProfile:
            return 16
        }
    }
    
    var layerCornerRadius: CGFloat {
        return min(cornerRadius, height / 2)
    }
    
    var shadowOpacity: Float {
        switch self {
        case .category, .companionCategorySelected, .companionCategoryUnselected:
            return 0.10
        case .mapInfo:
            return 0.08
        case .personalityDefault, .personalityOrange,
                .categoryHonbapSelected, .categoryHonbapUnselected,
                .diningCategorySelected, .diningCategoryUnselected,
                .filterSortSelected, .filterSortUnselected,
                .tagStateSelected, .tagStateUnselected,
                .badgeVerification, .badgeProfile:
            return 0
        }
    }
    
    var shadowOffset: CGSize {
        return CGSize(width: 0, height: 2)
    }
    
    var shadowRadius: CGFloat {
        return 4
    }

    var iconTextSpacing: CGFloat {
        switch self {
        case .diningCategorySelected, .diningCategoryUnselected:
            return 2
        default:
            return 0
        }
    }

    var titleColorForIcon: Bool {
        switch self {
        case .companionCategorySelected, .diningCategorySelected, .diningCategoryUnselected:
            return true
        default:
            return false
        }
    }
    
    var isSelected: Bool {
        switch self {
        case .personalityOrange, .companionCategorySelected, .categoryHonbapSelected,
                .diningCategorySelected,
                .filterSortSelected, .tagStateSelected:
            return true
        case .personalityDefault, .categoryHonbapUnselected,
                .category, .companionCategoryUnselected, .diningCategoryUnselected,
                .filterSortUnselected, .tagStateUnselected,
                .mapInfo, .badgeProfile, .badgeVerification:
            return false
        }
    }
    
    var isSelectable: Bool {
        switch self {
        case .personalityDefault, .personalityOrange,
                .companionCategorySelected, .companionCategoryUnselected,
                .categoryHonbapSelected, .categoryHonbapUnselected,
                .diningCategorySelected, .diningCategoryUnselected,
                .filterSortSelected, .filterSortUnselected,
                .tagStateSelected, .tagStateUnselected:
            return true
        case .category, .mapInfo, .badgeProfile, .badgeVerification:
            return false
        }
    }
    
    var selectedStyle: NearbyChipStyle {
        switch self {
        case .personalityDefault, .personalityOrange:
            return .personalityOrange
        case .companionCategorySelected, .companionCategoryUnselected:
            return .companionCategorySelected
        case .categoryHonbapUnselected, .categoryHonbapSelected:
            return .categoryHonbapSelected
        case .diningCategoryUnselected, .diningCategorySelected:
            return .diningCategorySelected
        case .filterSortSelected, .filterSortUnselected:
            return .filterSortSelected
        case .tagStateSelected, .tagStateUnselected:
            return .tagStateSelected
        case .category, .mapInfo, .badgeProfile, .badgeVerification:
            return self
        }
    }
    
    var unselectedStyle: NearbyChipStyle {
        switch self {
        case .personalityDefault, .personalityOrange:
            return .personalityDefault
        case .companionCategorySelected, .companionCategoryUnselected:
            return .companionCategoryUnselected
        case .categoryHonbapUnselected, .categoryHonbapSelected:
            return .categoryHonbapUnselected
        case .diningCategoryUnselected, .diningCategorySelected:
            return .diningCategoryUnselected
        case .filterSortSelected, .filterSortUnselected:
            return .filterSortUnselected
        case .tagStateSelected, .tagStateUnselected:
            return .tagStateUnselected
        case .category, .mapInfo, .badgeProfile, .badgeVerification:
            return self
        }
    }
}
