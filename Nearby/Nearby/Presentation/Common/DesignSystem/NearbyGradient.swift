//
//  NearbyGradient.swift
//  Nearby
//
//  Created by 장지인 on 7/4/26.
//

import UIKit

enum NearbyGradient {
    static var buttonBackgroundColors: [CGColor] {
        [
            UIColor(named: "btn_gradation_bg_start")?.cgColor ?? UIColor.gradientStart.cgColor,
            UIColor(named: "btn_gradation_bg_end")?.cgColor ?? UIColor.gradientEnd.cgColor
        ]
    }

    static func buttonBackgroundLayer(frame: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = buttonBackgroundColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        return gradientLayer
    }
    
    static func profileBorderLayer(frame: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = buttonBackgroundColors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        return gradientLayer
    }
}
