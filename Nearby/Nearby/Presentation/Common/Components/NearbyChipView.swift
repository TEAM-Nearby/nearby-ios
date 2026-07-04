//
//  NearbyChipView.swift
//  Nearby
//
//  Created by 장지인 on 7/4/26.
//

import UIKit

import SnapKit

final class NearbyChipView: BaseView {
    
    // MARK: - Properties
    
    private let style: NearbyChipStyle
    private let horizontalInset: CGFloat
    private var isSelected: Bool = false
    
    // MARK: - UI Component
    
    private var chipTextLabel = UILabel()
    
    // MARK: - Initializers
    
    init(style: NearbyChipStyle, title: String, horizontalInset: CGFloat) {
        self.style = style
        self.horizontalInset = horizontalInset
        super.init(frame: .zero)
        
        isSelected = style.isSelected
        setChipStyle(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func setStyle() {
        clipsToBounds = false
        layer.borderWidth = 1
        layer.cornerRadius = style.layerCornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = style.shadowOffset
        layer.shadowRadius = style.shadowRadius
        layer.shadowOpacity = style.shadowOpacity
        
        if style.isSelectable {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chipDidTap))
            addGestureRecognizer(tapGesture)
        }
    }
    
    override func setUI() {
        addSubview(chipTextLabel)
    }
    
    override func setLayout() {
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
    
    func setSelected(_ selected: Bool) {
        isSelected = selected
        updateUI()
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
        
        if let range = title.range(of: #"\d+개"#, options: .regularExpression) {
            attributedString.addAttribute(
                .foregroundColor,
                value: UIColor.btnPrimaryBg,
                range: NSRange(range, in: title)
            )
        }
        
        chipTextLabel.attributedText = attributedString
    }
    
    // MARK: - Action
    
    @objc
    private func chipDidTap() {
        setSelected(!isSelected)
    }
}
