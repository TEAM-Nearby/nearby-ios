//
//  UIFont+.swift
//  Nearby
//
//  Created by soomin on 7/2/26.
//

import UIKit

extension UIFont {
    enum FontType {
        case bold
        case semibold
        case medium
        case regular
        
        var name: String {
            switch self {
            case .bold: return "Pretendard-Bold"
            case .semibold: return "Pretendard-SemiBold"
            case .medium:   return "Pretendard-Medium"
            case .regular:  return "Pretendard-Regular"
            }
        }
    }
}
