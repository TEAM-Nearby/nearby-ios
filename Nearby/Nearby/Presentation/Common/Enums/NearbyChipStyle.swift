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
    case categoryHonbapSelected
    case categoryHonbapUnselected
    case filterSortSelected
    case filterSortUnselected
    case tagStateSelected
    case tagStateUnselected
    case mapInfo
    case badgeVerification
    case badgeProfile
    
    var backgroundColor: UIColor {
        switch self {
        case .personalityDefault, .category, .tagStateUnselected, .mapInfo:
            return .white
        case .personalityOrange:
            return .chipPersonalityBgOrange
        case .categoryHonbapSelected, .filterSortSelected, .tagStateSelected:
            return .chipBgPurple
        case .categoryHonbapUnselected, .filterSortUnselected, .badgeProfile:
            return .chipBgGrey
        case .badgeVerification:
            return .bgDefaultGey
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .personalityDefault, .filterSortUnselected, .tagStateUnselected:
            return .grey50
        case .personalityOrange:
            return .chipPersonalityTextOrange
        case .category:
            return .grey90
        case .categoryHonbapUnselected, .badgeProfile:
            return .grey40
        case .categoryHonbapSelected, .tagStateSelected:
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
        case .personalityDefault, .categoryHonbapUnselected, .tagStateUnselected:
            return .grey10
        case .filterSortUnselected:
            return .chipBorderGrey
        case .personalityOrange, .category, .categoryHonbapSelected,
                .tagStateSelected, .mapInfo, .badgeProfile,
                .badgeVerification, .filterSortSelected:
            return UIColor.clear
        }
    }
    
    var font: UIFont {
        switch self {
        case .personalityOrange, .personalityDefault, .category,
                .categoryHonbapUnselected, .tagStateSelected,
                .tagStateUnselected, .filterSortUnselected:
            return NearbyFont.b3M14.font
        case .categoryHonbapSelected, .filterSortSelected:
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
        case .personalityDefault, .personalityOrange:
            return 36
        case .category, .categoryHonbapSelected, .categoryHonbapUnselected,
                .filterSortSelected, .filterSortUnselected:
            return 32
        case .tagStateSelected, .tagStateUnselected:
            return 36
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
                .category, .categoryHonbapSelected, .categoryHonbapUnselected,
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
        case .category:
            return 0.10
        case .mapInfo:
            return 0.08
        case .personalityDefault, .personalityOrange,
                .categoryHonbapSelected, .categoryHonbapUnselected,
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
    
    var isSelected: Bool {
        switch self {
        case .categoryHonbapSelected, .filterSortSelected, .tagStateSelected:
            return true
        case .personalityOrange, .personalityDefault, .categoryHonbapUnselected,
                .category, .filterSortUnselected, .tagStateUnselected,
                .mapInfo, .badgeProfile, .badgeVerification:
            return false
        }
    }
    
    var isSelectable: Bool {
        switch self {
        case .categoryHonbapSelected, .categoryHonbapUnselected,
                .filterSortSelected, .filterSortUnselected,
                .tagStateSelected, .tagStateUnselected:
            return true
        case .personalityOrange, .personalityDefault, .category,
                .mapInfo, .badgeProfile, .badgeVerification:
            return false
        }
    }
    
    var selectedStyle: NearbyChipStyle {
        switch self {
        case .categoryHonbapUnselected, .categoryHonbapSelected:
            return .categoryHonbapSelected
        case .filterSortSelected, .filterSortUnselected:
            return .filterSortSelected
        case .tagStateSelected, .tagStateUnselected:
            return .tagStateSelected
        case .personalityOrange, .personalityDefault, .category, .mapInfo, .badgeProfile, .badgeVerification:
            return self
        }
    }
    
    var unselectedStyle: NearbyChipStyle {
        switch self {
        case .categoryHonbapUnselected, .categoryHonbapSelected:
            return .categoryHonbapUnselected
        case .filterSortSelected, .filterSortUnselected:
            return .filterSortUnselected
        case .tagStateSelected, .tagStateUnselected:
            return .tagStateUnselected
        case .personalityOrange, .personalityDefault, .category, .mapInfo, .badgeProfile, .badgeVerification:
            return self
        }
    }
}
