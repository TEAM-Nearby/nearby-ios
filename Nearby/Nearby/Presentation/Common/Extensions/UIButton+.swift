//
//  UIButton+.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import UIKit
import SnapKit

extension UIButton {
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
    
    private static let underlineViewTag = 9401
    func setUnderline(gap: CGFloat = 1, thickness: CGFloat = 2 / UIScreen.main.scale) {
        guard let titleLabel else { return }
        
        viewWithTag(Self.underlineViewTag)?.removeFromSuperview()
        
        let underlineView = UIView()
        underlineView.tag = Self.underlineViewTag
        underlineView.backgroundColor = titleColor(for: .normal)
        underlineView.isUserInteractionEnabled = false
        addSubview(underlineView)
        
        underlineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(gap)
            $0.horizontalEdges.equalTo(titleLabel)
            $0.height.equalTo(thickness)
        }
    }
}
