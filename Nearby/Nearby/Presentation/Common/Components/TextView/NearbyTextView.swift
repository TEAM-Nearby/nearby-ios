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
    
    // MARK: - Properties
    
    private let placeholder: String
    private let contentInsets: UIEdgeInsets
    
    var text: String { textView.text ?? "" }
    
    var isClearButtonHidden: Bool = false {
        didSet {
            clearButton.isHidden = isClearButtonHidden
            remakeTextViewConstraints()
        }
    }
    
    var onTextChanged: ((String) -> Void)?
    
    // MARK: - Initializer
    
    init(placeholder: String, contentInsets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 28, bottom: 16, right: 28)) {
        self.placeholder = placeholder
        self.contentInsets = contentInsets
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
            $0.delegate = self
        }
        
        placeholderLabel.do {
            $0.setFont(.b3M14, text: placeholder, textColor: .grey20)
        }
        
        clearButton.do {
            $0.setImage(.cancelIcon.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .grey20
        }
    }
    
    override func setUI() {
        addSubviews(textView, placeholderLabel, clearButton)
    }
    
    override func setLayout() {
        remakeTextViewConstraints()
        
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        clearButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(contentInsets.top)
            $0.trailing.equalToSuperview().inset(contentInsets.right)
            $0.size.equalTo(24)
        }
    }
    
    // MARK: - Methods
    
    private func remakeTextViewConstraints() {
        textView.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(contentInsets.top)
            $0.leading.equalToSuperview().offset(contentInsets.left)
            $0.bottom.equalToSuperview().inset(contentInsets.bottom)
            if isClearButtonHidden {
                $0.trailing.equalToSuperview().inset(contentInsets.right)
            } else {
                $0.trailing.equalTo(clearButton.snp.leading).offset(-12)
            }
        }
    }
    
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

// MARK: - UITextViewDelegate

extension NearbyTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        onTextChanged?(textView.text)
    }
}
