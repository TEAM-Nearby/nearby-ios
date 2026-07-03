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
            UIColor(named: "btn_gradation_bg_start")?.cgColor ?? UIColor(red: 0x61 / 255, green: 0x48 / 255, blue: 0xFF / 255, alpha: 1).cgColor,
            UIColor(named: "btn_gradation_bg_end")?.cgColor ?? UIColor(red: 0x7B / 255, green: 0xAE / 255, blue: 0xFF / 255, alpha: 1).cgColor
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
}
