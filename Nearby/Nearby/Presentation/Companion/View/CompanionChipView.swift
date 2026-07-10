//
//  CompanionChipView.swift
//  Nearby
//
//  Created by soomin on 7/10/26.
//

import UIKit

import SnapKit
import Then

final class CompanionChipView: BaseView {
    private enum Metric {
        static let backgroundHeight: CGFloat = 108
        static let arrowHeight: CGFloat = 21
        static let arrowOverlap: CGFloat = 11
        static let arrowTipY: CGFloat = 12.2
    }

    override var intrinsicContentSize: CGSize {
        let headerWidth = headerStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
        let infoWidth = infoStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width

        return CGSize(width: ceil(max(headerWidth, infoWidth) + 40), height: Metric.backgroundHeight + Metric.arrowHeight - Metric.arrowOverlap)
    }

    var mapGroundAnchor: CGPoint {
        let arrowOriginY = Metric.backgroundHeight - Metric.arrowOverlap
        let tipY = arrowOriginY + Metric.arrowTipY
        return CGPoint(x: 0.5, y: tipY / intrinsicContentSize.height)
    }
    
    // MARK: - UI Components
    
    private let balloonBackgroundImageView = UIImageView()
    private let balloonArrowImageView = UIImageView()
    
    private let contentStackView = UIStackView()
    private let headerStackView = UIStackView()
    private let nicknameLabel = UILabel()
    private let writtenLabel = UILabel()
    
    private let infoStackView = UIStackView()
    
    private let placeStackView = UIStackView()
    private let placeIconImageView = UIImageView()
    private let placeLabel = UILabel()
    
    private let dateStackView = UIStackView()
    private let dateIconImageView = UIImageView()
    private let dateLabel = UILabel()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .clear
        
        balloonBackgroundImageView.do {
            $0.image = UIImage.ballonTop.resizableImage(withCapInsets: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), resizingMode: .stretch)
            $0.contentMode = .scaleToFill
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        
        balloonArrowImageView.do {
            $0.image = .ballonBottom
        }
        
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .leading
        }
        
        headerStackView.do {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.alignment = .center
        }
        
        nicknameLabel.do {
            $0.setFont(.b3Sb14, textColor: .grey80)
        }
        
        writtenLabel.do {
            $0.setFont(.b3M14, textColor: .grey20)
        }
        
        infoStackView.do {
            $0.axis = .vertical
            $0.spacing = 5
            $0.alignment = .leading
        }
        
        placeStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.alignment = .center
        }
        
        dateStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.alignment = .center
        }
        
        placeIconImageView.do {
            $0.image = .smallLocationBlackIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .primary50
        }
        
        dateIconImageView.do {
            $0.image = .smallCalenderIcon.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .primary50
        }
        
        placeLabel.do {
            $0.setFont(.b3M14, textColor: .grey60)
            $0.transform = CGAffineTransform(translationX: 0, y: -1)
        }
        
        dateLabel.do {
            $0.setFont(.b3M14, textColor: .grey60)
            $0.transform = CGAffineTransform(translationX: 0, y: -1)
        }
    }
    
    override func setUI() {
        headerStackView.addArrangedSubviews(nicknameLabel, writtenLabel)
        placeStackView.addArrangedSubviews(placeIconImageView, placeLabel)
        dateStackView.addArrangedSubviews(dateIconImageView, dateLabel)
        infoStackView.addArrangedSubviews(placeStackView, dateStackView)
        contentStackView.addArrangedSubviews(headerStackView, infoStackView)
        addSubviews(balloonBackgroundImageView, balloonArrowImageView, contentStackView)
    }
    
    override func setLayout() {
        balloonBackgroundImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Metric.backgroundHeight)
        }
        
        contentStackView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(balloonBackgroundImageView).inset(20)
            $0.centerY.equalTo(balloonBackgroundImageView).offset(-2)
        }
        
        placeIconImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        dateIconImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        balloonArrowImageView.snp.makeConstraints {
            $0.top.equalTo(balloonBackgroundImageView.snp.bottom).offset(-Metric.arrowOverlap)
            $0.centerX.equalTo(balloonBackgroundImageView)
            $0.size.equalTo(CGSize(width: 27, height: Metric.arrowHeight))
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Method
    
    func configure(nickname: String, written: String, place: String, date: String) {
        nicknameLabel.setFont(.b3Sb14, text: nickname, textColor: .grey80)
        writtenLabel.setFont(.b3M14, text: written, textColor: .grey30)
        placeLabel.setFont(.b3M14, text: place, textColor: .grey60)
        dateLabel.setFont(.b3M14, text: date, textColor: .grey60)
        invalidateIntrinsicContentSize()
    }
}
