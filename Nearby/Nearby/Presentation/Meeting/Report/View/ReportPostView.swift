//
//  ReportPostView.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

import UIKit

import SnapKit
import Then

final class ReportPostView: BaseView {
    
    // MARK: - UI Components
    
    private let navigationBar = NearbyNavigationBar()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let labelStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    let reasonTableView = SelfSizingTableView()
    
    private let reasonTextView = NearbyTextView(placeholder: "신고와 관련된 상세 내용을 입력해주세요. (선택)", contentInsets: UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 16))
    
    private let reportButton = NearbyButton(style: .primary, title: "신고하기")
    
    // MARK: - Properties
    
    var onTextChanged: ((String) -> Void)?
    var onBackButtonDidTap: (() -> Void)?
    var onReportButtonDidTap: (() -> Void)?
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        navigationBar.do {
            $0.configure(leftItem: .back, centerItem: .title("신고하기"))
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
        }
        
        titleLabel.do {
            $0.setFont(.h1Sb24, text: "어떤 점이 불편하셨나요?", textColor: .grey80)
            $0.textAlignment = .left
        }
        
        subtitleLabel.do {
            $0.setFont(.b2M16, text: "신고하신 내용은 비공개로 안전하게 처리됩니다.", textColor: .grey40)
        }
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
            $0.keyboardDismissMode = .interactive
        }
        
        reasonTableView.do {
            $0.separatorStyle = .none
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 65
            $0.backgroundColor = .clear
        }
        
        reasonTextView.do {
            $0.isClearButtonHidden = true
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
            $0.onTextChanged = { [weak self] text in
                self?.onTextChanged?(text)
            }
        }
    }
    
    override func setUI() {
        addSubviews(navigationBar, scrollView, reportButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(labelStackView, reasonTableView, reasonTextView)
        labelStackView.addArrangedSubviews(titleLabel, subtitleLabel)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(reportButton.snp.top).offset(-12)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        reasonTableView.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        reasonTextView.snp.makeConstraints {
            $0.top.equalTo(reasonTableView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(153)
            $0.bottom.equalToSuperview().offset(-24)
        }
        
        reportButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
            $0.bottom.lessThanOrEqualTo(safeAreaLayoutGuide)
            $0.bottom.lessThanOrEqualTo(keyboardLayoutGuide.snp.top).offset(-16)
            $0.bottom.equalTo(safeAreaLayoutGuide).priority(.low)
        }
    }
    
    override func setAddTarget() {
        navigationBar.leftButtonAction = { [weak self] in
            self?.onBackButtonDidTap?()
        }
        reportButton.addTarget(self, action: #selector(reportButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Method
    
    func updateReportButton(isEnabled: Bool) {
        reportButton.isEnabled = isEnabled
    }

    func updateDetailInput(isEnabled: Bool) {
        reasonTextView.textView.isEditable = isEnabled
        reasonTextView.alpha = isEnabled ? 1.0 : 0.5
        if !isEnabled {
            reasonTextView.textView.resignFirstResponder()
            reasonTextView.clearText()
        }
    }
    
    // MARK: - Action
    
    @objc
    private func reportButtonDidTap() {
        onReportButtonDidTap?()
    }
}
