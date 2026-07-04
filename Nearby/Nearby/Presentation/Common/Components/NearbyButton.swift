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
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setButtonStyle(title: String) {
        backgroundColor = style.backgroundColor
        layer.cornerRadius = 16
        setTitle(title, for: .normal)
        setTitleColor(style.titleColor, for: .normal)
        titleLabel?.font = NearbyFont.b2Sb16.font
    }
    
    func setSelected(_ selected: Bool) {
        isSelected = selected
        updateUI()
    }
    
    private func updateUI() {
        let toggleStyle: NearbyButtonStyle = isSelected ? .selected : .unselected
        backgroundColor = toggleStyle.backgroundColor
        setTitleColor(toggleStyle.titleColor, for: .normal)
    }
}
