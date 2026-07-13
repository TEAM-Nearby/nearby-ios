//
//  NearbyButtonStyle.swift
//  Nearby
//
//  Created by h2e on 7/4/26.
//

import UIKit

enum NearbyButtonStyle: Equatable {
    case primary
    case disabled
    case allowed
    case rejected
    case selected
    case unselected
    case gradient
    
    var usesGradient: Bool {
        switch self {
        case .gradient:
            return true
        default:
            return false
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .primary, .allowed, .selected:
            return .btnPrimaryBg
        case .disabled:
            return .grey10
        case .rejected:
            return .chipBgPurple
        case .unselected:
            return .bgSurfaceGrey0
        case .gradient:
            return .clear
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .primary, .allowed, .selected, .gradient:
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
        case .selected, .unselected, .gradient:
            return 12
        }
    }
    
    var title: String? {
        switch self {
        case .allowed:  return "수락하러 가기"
        case .rejected: return "거절하기"
        case .gradient: return "만남 인증하기"
        case .primary, .disabled, .selected, .unselected:
            return nil
        }
    }
    
    var font: NearbyFont {
        switch self {
        case .primary, .disabled, .allowed, .rejected, .selected, .unselected:
            return .b2Sb16
        case .gradient:
            return .b3M14
        }
    }
}
