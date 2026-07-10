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
    private var titleContentInsets: UIEdgeInsets = .zero
    
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

        guard titleContentInsets != .zero else { return }

        titleLabel?.frame.origin.x += titleContentInsets.left - titleContentInsets.right
        titleLabel?.frame.origin.y += titleContentInsets.top - titleContentInsets.bottom
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
        if !isEnabled {
            applyStyle(.disabled)
        } else {
            applyStyle(style)
        }
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

    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled

        let buttonStyle: NearbyButtonStyle = enabled ? style : .disabled
        backgroundColor = buttonStyle.backgroundColor
        setTitleColor(buttonStyle.titleColor, for: .normal)
    }

    func setPaddedTitle(
        _ title: String,
        font: NearbyFont,
        titleColor: UIColor,
        titleInsets: UIEdgeInsets
    ) {
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = font.font
        titleContentInsets = titleInsets
        setNeedsLayout()
    }
}
