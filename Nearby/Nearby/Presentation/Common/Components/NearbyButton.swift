//
//  NearbyButton.swift
//  Nearby
//
//  Created by h2e on 7/4/26.
//

import UIKit

final class NearbyButton: UIButton {
    
    // MARK: - Property
    
    private let style: NearbyButtonStyle
    
    // MARK: - Initializer
    
    init(style: NearbyButtonStyle, title: String) {
        self.style = style
        super.init(frame: .zero)
        
        setButtonStyle(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Method
    
    private func setButtonStyle(title: String) {
        backgroundColor = style.backgroundColor
        layer.cornerRadius = 16
        titleLabel?.setFont(.b2Sb16, text: title)
        setTitleColor(style.titleColor, for: .normal)
    }
}
