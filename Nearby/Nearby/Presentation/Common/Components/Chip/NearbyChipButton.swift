//
//  NearbyChipButton.swift
//  Nearby
//
//  Created by 장지인 on 7/4/26.
//

import UIKit

import SnapKit

final class NearbyChipButton: UIButton, NearbyChipShadowStyling {
    
    // MARK: - Properties
    
    private let style: NearbyChipStyle
    private let horizontalInset: CGFloat
    
    let chipTitle: String
    
    // MARK: - UI Component
    
    private let chipTextLabel = UILabel()
    
    // MARK: - Initializer
    
    init(style: NearbyChipStyle, title: String, horizontalInset: CGFloat) {
        self.style = style
        self.horizontalInset = horizontalInset
        self.chipTitle = title
        super.init(frame: .zero)

        isSelected = style.isSelected
        setStyle()
        setUI()
        setLayout()
        setChipStyle(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateChipShadowPath(style: style)
    }
    
    // MARK: - Custom Methods
    
    private func setStyle() {
        applyChipShadow(style: style)
    }
    
    private func setUI() {
        addSubview(chipTextLabel)
    }
    
    private func setLayout() {
        snp.makeConstraints {
            $0.height.equalTo(style.height)
        }
        
        chipTextLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
        }
    }
    
    private func setChipStyle(title: String) {
        backgroundColor = style.backgroundColor
        layer.borderColor = style.borderColor.cgColor
        layer.cornerRadius = style.layerCornerRadius
        chipTextLabel.textColor = style.titleColor
        chipTextLabel.font = style.font
        setChipTitle(title, titleColor: style.titleColor)
    }

    private func updateUI() {
        let toggleStyle = isSelected ? style.selectedStyle : style.unselectedStyle
        
        backgroundColor = toggleStyle.backgroundColor
        layer.borderColor = toggleStyle.borderColor.cgColor
        layer.cornerRadius = toggleStyle.layerCornerRadius
        chipTextLabel.textColor = toggleStyle.titleColor
        chipTextLabel.font = toggleStyle.font
        setChipTitle(chipTitle, titleColor: toggleStyle.titleColor)
    }
    
    private func setChipTitle(_ title: String, titleColor: UIColor) {
        guard style == .mapInfo else {
            chipTextLabel.attributedText = nil
            chipTextLabel.text = title
            return
        }
        
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttributes(
            [
                .foregroundColor: titleColor,
                .font: style.font
            ],
            range: NSRange(location: 0, length: attributedString.length)
        )
        
        if let range = title.range(of: #"\d+개"#, options: .regularExpression) {
            attributedString.addAttribute(
                .foregroundColor,
                value: UIColor.btnPrimaryBg,
                range: NSRange(range, in: title)
            )
        }
        
        chipTextLabel.attributedText = attributedString
    }
    
    // MARK: - Methods
    
    func updateSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
        updateUI()
    }
}
