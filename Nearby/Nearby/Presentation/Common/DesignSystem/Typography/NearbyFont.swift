//
//  NearbyFont.swift
//  Nearby
//
//  Created by mandoo on 7/3/26.
//

import UIKit

enum NearbyFont {
    case h1Sb24
    case h2M22
    case h3Sb20
    case h3M20
    
    case b1Sb18
    case b1M18
    case b2Sb16
    case b2M16
    case b3Sb14
    case b3M14
    case b3R14
    
    case c1Sb12
    case c1M12
    case c1M14
    case c1R12
    
    var property: FontProperty {
        switch self {
        case .h1Sb24: return FontProperty(fontType: .semibold, size: 24)
        case .h2M22:  return FontProperty(fontType: .medium, size: 22)
        case .h3Sb20: return FontProperty(fontType: .semibold, size: 20)
        case .h3M20:  return FontProperty(fontType: .medium, size: 20)
            
        case .b1Sb18: return FontProperty(fontType: .semibold, size: 18)
        case .b1M18:  return FontProperty(fontType: .medium, size: 18)
        case .b2Sb16: return FontProperty(fontType: .semibold, size: 16)
        case .b2M16:  return FontProperty(fontType: .medium, size: 16)
        case .b3Sb14: return FontProperty(fontType: .semibold, size: 14)
        case .b3M14:  return FontProperty(fontType: .medium, size: 14)
        case .b3R14:  return FontProperty(fontType: .regular, size: 14)
            
        case .c1Sb12: return FontProperty(fontType: .semibold, size: 12)
        case .c1M12:  return FontProperty(fontType: .medium, size: 12)
        case .c1M14:  return FontProperty(fontType: .medium, size: 14)
        case .c1R12:  return FontProperty(fontType: .regular, size: 12)
        }
    }
    
    var font: UIFont {
        let type = property.fontType
        let size = property.size
        
        guard let nearbyFont = UIFont(name: type.name, size: size) else {
            let systemWeight: UIFont.Weight
            switch type {
            case .semibold: systemWeight = .semibold
            case .medium: systemWeight = .medium
            case .regular: systemWeight = .regular
            }
            return .systemFont(ofSize: size, weight: systemWeight)
        }
        return nearbyFont
    }
}
