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
    
    private let labelStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    let reasonTableView = UITableView()
    
    private let reasonTextView = NearbyTextView(placeholder: "신고와 관련된 상세 내용을 입력해주세요. (선택)", contentInsets: UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 16))
    
    private let reportButton = NearbyButton(style: .disabled, title: "신고하기")
    
    // MARK: - Properties
    
    private var selectedReasons = Set<Int>()
    var onTextChanged: ((String) -> Void)?
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
        
        reasonTableView.do {
            $0.separatorStyle = .none
            $0.rowHeight = 44
            $0.isScrollEnabled = false
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
        addSubviews(navigationBar, labelStackView, reasonTableView, reportButton)
        labelStackView.addArrangedSubviews(titleLabel, subtitleLabel)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        reasonTableView.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(280)
        }
        
        reasonTextView.snp.makeConstraints {
            $0.top.equalTo(reasonTableView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(153)
        }
        
        reportButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
    }
    
    override func setAddTarget() {
        reportButton.addTarget(self, action: #selector(reportButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Method
    
    func updateReportButton(isEnabled: Bool) {
        reportButton.isEnabled = isEnabled
    }
    
    // MARK: - Action
    
    @objc
    private func reportButtonDidTap() {
        onReportButtonDidTap?()
    }
}
