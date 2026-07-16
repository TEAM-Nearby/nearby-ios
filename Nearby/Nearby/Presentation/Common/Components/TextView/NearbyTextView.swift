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
    private var placeholderTopConstraint: Constraint?
    private let placeholderVerticalAdjustment: CGFloat = -2
    private let textFont: NearbyFont = .b3M14
    
    var text: String { textView.text ?? "" }
    
    var isClearButtonHidden: Bool = false {
        didSet {
            clearButton.isHidden = isClearButtonHidden
            remakeTextViewConstraints()
        }
    }

    var verticallyCentersSingleLineText: Bool = false {
        didSet {
            remakeTextViewConstraints()
            setNeedsLayout()
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

    override func layoutSubviews() {
        super.layoutSubviews()

        updateTextVerticalInset()
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .bgSurfaceGrey0
        layer.cornerRadius = 16
        clipsToBounds = true
        
        textView.do {
            $0.backgroundColor = .clear
            $0.textColor = .grey80
            $0.textContainerInset = .zero
            $0.textContainer.lineFragmentPadding = 0
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.smartDashesType = .no
            $0.smartQuotesType = .no
            $0.smartInsertDeleteType = .no
            $0.delegate = self
            applyTextViewTypography()
        }
        
        placeholderLabel.do {
            $0.setFont(textFont, text: placeholder, textColor: .grey20)
        }
        
        clearButton.do {
            $0.setImage(.cancelIcon.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .grey80
        }
    }
    
    override func setUI() {
        addSubviews(textView, placeholderLabel, clearButton)
    }
    
    override func setLayout() {
        remakeTextViewConstraints()
        
        placeholderLabel.snp.makeConstraints {
            placeholderTopConstraint = $0.top.equalToSuperview().offset(contentInsets.top).constraint
            $0.leading.equalTo(textView.snp.leading)
            $0.trailing.equalTo(textView.snp.trailing)
            $0.bottom.lessThanOrEqualTo(textView.snp.bottom)
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
            $0.leading.equalToSuperview().offset(contentInsets.left)
            if isClearButtonHidden {
                $0.trailing.equalToSuperview().inset(contentInsets.right)
            } else {
                $0.trailing.equalTo(clearButton.snp.leading).offset(-12)
            }

            if verticallyCentersSingleLineText {
                $0.top.bottom.equalToSuperview()
            } else {
                $0.top.equalToSuperview().offset(contentInsets.top)
                $0.bottom.equalToSuperview().inset(contentInsets.bottom)
            }
        }
    }

    private func updateTextVerticalInset() {
        guard verticallyCentersSingleLineText, bounds.height > 0 else {
            textView.textContainerInset = .zero
            placeholderTopConstraint?.update(offset: contentInsets.top)
            return
        }

        let lineHeight = textFont.property.lineHeight
        let topInset = max(0, (bounds.height - lineHeight) / 2)
        textView.textContainerInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        placeholderTopConstraint?.update(offset: topInset + placeholderVerticalAdjustment)
    }

    private func applyTextViewTypography() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = textFont.property.lineHeight
        paragraphStyle.maximumLineHeight = textFont.property.lineHeight

        let baselineOffset = (textFont.property.lineHeight - textFont.font.lineHeight) / 4
        let attributes: [NSAttributedString.Key: Any] = [
            .font: textFont.font,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: baselineOffset,
            .foregroundColor: UIColor.grey80
        ]

        textView.font = textFont.font
        textView.typingAttributes = attributes
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
        setNeedsLayout()
    }
}

// MARK: - UITextViewDelegate

extension NearbyTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        onTextChanged?(textView.text)
    }
}
