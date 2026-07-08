//
//  NearbyTextView.swift
//  Nearby
//
//  Created by 신서연 on 7/8/26.
//

import UIKit

import SnapKit
import Then

final class NearbyTextView: BaseView {
    
    // MARK: - UI Components
    
    let textView = UITextView()
    
    private let placeholderLabel = UILabel()
    let clearButton = UIButton(type: .system)
    
    // MARK: - Property
    
    private let placeholder: String
    
    // MARK: - Initializer
    
    init(placeholder: String) {
        self.placeholder = placeholder
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .bgSurfaceGrey0
        layer.cornerRadius = 16
        clipsToBounds = true
        
        textView.do {
            $0.backgroundColor = .clear
            $0.font = NearbyFont.b3M14.font
            $0.textColor = .grey80
            $0.textContainerInset = .zero
            $0.textContainer.lineFragmentPadding = 0
        }
        
        placeholderLabel.do {
            $0.setFont(.b3M14, text: placeholder, textColor: .grey20)
        }
        
        clearButton.do {
            $0.setImage(.cancelIcon.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .grey20
            $0.isHidden = false
        }
    }
    
    override func setUI() {
        addSubviews(textView, clearButton)
        textView.addSubview(placeholderLabel)
    }
    
    override func setLayout() {
        textView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(28)
            $0.trailing.equalTo(clearButton.snp.leading).offset(-12)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        clearButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(28)
            $0.size.equalTo(24)
        }
    }
}

// MARK: - Methods

extension NearbyTextView {
    func updatePlaceholder(isHidden: Bool) {
        placeholderLabel.isHidden = isHidden
    }

    func clearText() {
        textView.text = nil
        placeholderLabel.isHidden = false
    }
    
    func setPlaceholderTruncation(numberOfLines: Int) {
        placeholderLabel.numberOfLines = numberOfLines
        placeholderLabel.lineBreakMode = .byTruncatingTail
    }
}
