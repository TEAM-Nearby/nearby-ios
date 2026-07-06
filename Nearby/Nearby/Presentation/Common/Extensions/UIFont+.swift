//
//  UIFont+.swift
//  Nearby
//
//  Created by soomin on 7/2/26.
//

import UIKit

extension UIFont {
    enum FontType {
        case semibold
        case medium
        case regular
        
        var name: String {
            switch self {
            case .semibold: return "Pretendard-SemiBold"
            case .medium:   return "Pretendard-Medium"
            case .regular:  return "Pretendard-Regular"
            }
        }
    }
}
