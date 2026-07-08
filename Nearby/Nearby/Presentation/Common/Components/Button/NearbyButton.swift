//
//  NearbyButton.swift
//  Nearby
//
//  Created by h2e on 7/4/26.
//

import UIKit

final class NearbyButton: UIButton {
    
    // MARK: - Properties
    
    private let style: NearbyButtonStyle
    private var gradientLayer: CAGradientLayer?
    
    override var isEnabled: Bool {
        didSet {
            refreshStyle()
        }
    }
    
    // MARK: - Initializer
    
    init(style: NearbyButtonStyle, title: String) {
        self.style = style
        super.init(frame: .zero)
        
        setButtonStyle(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
    
    // MARK: - Methods
    
    private func setButtonStyle(title: String) {
        backgroundColor = style.backgroundColor
        layer.cornerRadius = 16
        setTitle(title, for: .normal)
        setTitleColor(style.titleColor, for: .normal)
        titleLabel?.font = style.font.font
        
        if style.usesGradient {
            setGradient()
        }
    }
    
    private func refreshStyle() {
        guard isEnabled else {
            applyStyle(.disabled)
            return
        }
        applyStyle(isSelected ? .selected : .unselected)
    }
    
    private func applyStyle(_ newStyle: NearbyButtonStyle) {
        backgroundColor = newStyle.backgroundColor
        setTitleColor(newStyle.titleColor, for: .normal)
        gradientLayer?.isHidden = !newStyle.usesGradient
    }
    
    private func setGradient() {
        let gradient = NearbyGradient.buttonBackgroundLayer(frame: bounds)
        gradient.cornerRadius = layer.cornerRadius
        layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
    
    func setSelected(_ selected: Bool) {
        isSelected = selected
        refreshStyle()
    }
}
