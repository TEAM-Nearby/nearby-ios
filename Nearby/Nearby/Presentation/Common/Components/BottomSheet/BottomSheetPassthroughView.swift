//
//  BottomSheetPassthroughView.swift
//  Nearby
//
//  Created by soomin on 7/10/26.
//

import UIKit

final class BottomSheetPassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        if hitView == self {
            return nil
        }
        
        return hitView
    }
}
