//
//  NearbyButtonStyle.swift
//  Nearby
//
//  Created by h2e on 7/4/26.
//

import UIKit

enum NearbyButtonStyle {
    case primary
    case disabled
    case allowed
    case rejected
    case selected
    case unselected
    
    var backgroundColor: UIColor {
        switch self {
        case .primary, .allowed, .selected:
            return .btnPrimaryBg
        case .disabled:
            return .grey10
        case .rejected:
            return .chipBgPurple
        case .unselected:
            return .grey80
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .primary, .allowed, .selected:
            return .white
        case .disabled:
            return .grey40
        case .rejected:
            return .grey80
        case .unselected:
            return .grey30
        }
    }
    
    var padding: CGFloat {
        switch self {
        case .primary, .disabled, .allowed, .rejected:
            return 17
        case .selected, .unselected:
            return 12
        }
    }
    
    var title: String? {
        switch self {
        case .allowed:  return "수락하기"
        case .rejected: return "거절하기"
        case .primary, .disabled, .selected, .unselected:
            return nil
        }
    }
}
