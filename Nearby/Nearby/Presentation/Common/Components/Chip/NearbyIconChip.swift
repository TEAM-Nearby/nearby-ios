//
//  NearbyIconChip.swift
//  Nearby
//
//  Created by soomin on 7/6/26.
//

import UIKit
import SnapKit

final class NearbyIconChip: UIButton, NearbyChipShadowStyling {
    
    // MARK: - Properties
    
    private let style: NearbyChipStyle
    private let title: String
    private let icon: UIImage
    private let iconColor: UIColor
    
    // MARK: - UI Components
    
    private let contentStackView = UIStackView()
    private let chipIconImageView = UIImageView()
    private let chipTextLabel = UILabel()
    
    // MARK: - Initializer
    
    init(style: NearbyChipStyle, title: String, icon: UIImage, iconColor: UIColor? = nil) {
        self.style = style
        self.title = title
        self.icon = icon
        self.iconColor = iconColor ?? style.titleColor
        super.init(frame: .zero)
        
        isSelected = style.isSelected
        setStyle()
        setUI()
        setLayout()
        setAddTarget()
        setChipStyle(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateChipShadowPath(style: style)
    }
    
    // MARK: - Methods
    
    private func setStyle() {
        applyChipShadow(style: style)
        
        contentStackView.axis = .horizontal
        contentStackView.alignment = .center
        contentStackView.spacing = style.iconTextSpacing
        contentStackView.isUserInteractionEnabled = false
        
        chipIconImageView.image = icon.withRenderingMode(.alwaysTemplate)
        chipIconImageView.contentMode = .scaleAspectFit
        
        chipTextLabel.text = title
        chipTextLabel.textAlignment = .center
        chipTextLabel.textColor = .grey90
    }
    
    private func setUI() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubviews(chipIconImageView, chipTextLabel)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(style.height)
        }
        
        contentStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        chipIconImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
    
    private func setAddTarget() {
        addTarget(self, action: #selector(chipDidTap), for: .touchUpInside)
    }
    
    private func setChipStyle(_ style: NearbyChipStyle) {
        backgroundColor = style.backgroundColor
        layer.borderColor = style.borderColor.cgColor
        chipIconImageView.tintColor = style.titleColorForIcon ? style.titleColor : iconColor
        chipTextLabel.textColor = style.titleColor
        chipTextLabel.font = style.font
        invalidateIntrinsicContentSize()
    }
    
    private func updateChipButton() {
        let toggleChipButton: NearbyChipStyle = isSelected ? style.selectedStyle : style.unselectedStyle
        setChipStyle(toggleChipButton)
    }

    func updateSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
        updateChipButton()
    }
    
    // MARK: - Action
    
    @objc
    private func chipDidTap() {
        guard style.isSelectable else { return }
        isSelected.toggle()
        updateChipButton()
    }
}
