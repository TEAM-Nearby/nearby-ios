//
//  FontProperty.swift
//  Nearby
//
//  Created by mandoo on 7/3/26.
//

import UIKit

struct FontProperty {
    let fontType: UIFont.FontType
    let size: CGFloat
    
    var lineHeight: CGFloat {
        return size * 1.4
    }
    
    init(fontType: UIFont.FontType, size: CGFloat) {
        self.fontType = fontType
        self.size = size
    }
}
