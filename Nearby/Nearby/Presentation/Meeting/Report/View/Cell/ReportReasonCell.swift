//
//  ReportReasonCell.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import UIKit

import SnapKit
import Then

final class ReportReasonCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let checkBox = UIImageView()
    
    private let titleLabel = UILabel()
    private let dividerView = UIView()
    
    // MARK: - Initiallizer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setStyle() {
        backgroundColor = .clear
        selectionStyle = .none
        
        checkBox.do {
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.setFont(.b2M16, text: "", textColor: .grey80)
        }
        
        dividerView.do {
            $0.backgroundColor = .grey10
        }
    }
    
    private func setUI() {
        contentView.addSubviews(checkBox, titleLabel, dividerView)
    }
    
    private func setLayout() {
        checkBox.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(checkBox.snp.trailing).offset(12)
            $0.centerY.equalTo(checkBox.snp.centerY)
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(checkBox.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
    }
    
    func configure(title: String, isChecked: Bool, isLast: Bool) {
        titleLabel.text = title
        checkBox.image = isChecked ? .checkboxSelect : .checkboxDefault
        dividerView.isHidden = isLast
    }
}

