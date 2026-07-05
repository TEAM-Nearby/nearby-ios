//
//  NearbyChipButton.swift
//  Nearby
//
//  Created by 장지인 on 7/4/26.
//

import SnapKit
import UIKit

final class NearbyChipView: UIButton {
    
    // MARK: - Properties
    
    private let style: NearbyChipStyle
    private let horizontalInset: CGFloat
    
    // MARK: - UI Component
    
    private var chipTextLabel = UILabel()
    
    // MARK: - Initializer
    
    init(style: NearbyChipStyle, title: String, horizontalInset: CGFloat) {
        self.style = style
        self.horizontalInset = horizontalInset
        super.init(frame: .zero)

        isSelected = style.isSelected
        setStyle()
        setUI()
        setLayout()
        setChipStyle(title: title)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setStyle() {
        clipsToBounds = false
        layer.borderWidth = 1
        layer.cornerRadius = style.layerCornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = style.shadowOffset
        layer.shadowRadius = style.shadowRadius
        layer.shadowOpacity = style.shadowOpacity
        
        isUserInteractionEnabled = style.isSelectable
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let shadowRect = bounds.offsetBy(dx: 0, dy: style.shadowOffset.height / 2)
        
        layer.shadowPath = UIBezierPath(
            roundedRect: shadowRect,
            cornerRadius: style.layerCornerRadius
        ).cgPath
    }
    
    private func setChipStyle(title: String) {
        backgroundColor = style.backgroundColor
        layer.borderColor = style.borderColor.cgColor
        chipTextLabel.textColor = style.titleColor
        chipTextLabel.font = style.font
        setChipTitle(title, titleColor: style.titleColor)
    }
    
    private func updateUI() {
        let toggleStyle: NearbyChipStyle = isSelected ? style.selectedStyle : style.unselectedStyle
        backgroundColor = toggleStyle.backgroundColor
        layer.borderColor = toggleStyle.borderColor.cgColor
        chipTextLabel.textColor = toggleStyle.titleColor
        chipTextLabel.font = toggleStyle.font
    }
    
    private func setChipTitle(_ title: String, titleColor: UIColor) {
        guard style == .mapInfo else {
            chipTextLabel.attributedText = nil
            chipTextLabel.text = title
            return
        }
        
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(
            .foregroundColor,
            value: titleColor,
            range: NSRange(location: 0, length: attributedString.length)
        )
        attributedString.addAttribute(
            .font,
            value: style.font,
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
    
    func setSelected(_ selected: Bool) {
        isSelected = selected
        updateUI()
    }
    
    private func bind() {
        addTarget(self, action: #selector(chipDidTap), for: .touchUpInside)
    }
    
    // MARK: - Action
    
    @objc
    private func chipDidTap() {
        guard style.isSelectable else { return }
        isSelected = !isSelected
        updateUI()
    }
}
