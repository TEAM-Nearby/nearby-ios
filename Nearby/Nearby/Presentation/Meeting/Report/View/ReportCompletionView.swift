//
//  ReportCompletionView.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import UIKit

import SnapKit
import Then

final class ReportCompletionView: BaseView {
    
    // MARK: - Property
    
    var onConfirmButtonDidTap: (() -> Void)?
    
    // MARK: - UI Components
    
    private let checkImageView = UIImageView()
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let confirmButton = NearbyButton(style: .primary, title: "확인")
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        checkImageView.do {
            $0.image = .imgCheck
        }
        
        titleLabel.do {
            $0.setFont(.h1Sb24, text: "신고가 접수되었어요", textColor: .grey80)
            $0.textAlignment = .center
        }
        
        subtitleLabel.do {
            $0.setFont(.b2M16, text: "검토한 뒤 빠르게 조치할게요.\n소중한 제보 감사합니다.", textColor: .grey40)
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
    }
    
    override func setUI() {
        addSubviews(checkImageView, titleLabel, subtitleLabel, confirmButton)
    }
    
    override func setLayout() {
        checkImageView.snp.makeConstraints {
            $0.top.equalTo(self.snp.centerY).offset(-118)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(64)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(checkImageView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
    }
    
    override func setAddTarget() {
        confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Action
    
    @objc
    private func confirmButtonDidTap() {
        onConfirmButtonDidTap?()
    }
}
