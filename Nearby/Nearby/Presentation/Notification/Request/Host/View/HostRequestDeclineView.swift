//
//  HostRequestDeclineView.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import UIKit

import SnapKit
import Then

final class HostRequestDeclineView: BaseView {
    
    // MARK: - Properties
    
    var onBackButtonDidTap: (() -> Void)?
    var onRejectButtonDidTap: (() -> Void)?
    
    // MARK: - UI Components
    
    private let navigationBar = NearbyNavigationBar()
    
    private let applicantProfileView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    private let rejectView = UIView()
    private let rejectReasonLabel = UILabel()
    private let rejectReasonTextBox = NearbyTextView(placeholder: "내용을 입력해주세요", contentInsets: UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20))
    
    private let rejectButton = NearbyButton(style: .primary, title: "")
    
    var rejectReasonText: String {
        rejectReasonTextBox.text
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        imageView.do {
            $0.contentMode = .scaleAspectFill
        }
        
        titleLabel.do {
            $0.setFont(.h2M22, text: "", textColor: .black)
            $0.textAlignment = .center
        }
        
        subTitleLabel.do {
            $0.setFont(.b2M16, text: "", textColor: .grey30)
            $0.textAlignment = .center
        }
        
        rejectReasonLabel.do {
            $0.setFont(.b2M16, text: "", textColor: .grey80)
            $0.textAlignment = .left
        }
        
        rejectReasonTextBox.do {
            $0.textView.textColor = .grey60
            $0.isClearButtonHidden = true
        }
        
        navigationBar.do {
            $0.configure(leftItem: .back)
        }
    }
    
    override func setUI() {
        addSubviews(navigationBar, applicantProfileView, rejectView, rejectButton)
        rejectView.addSubviews(rejectReasonLabel, rejectReasonTextBox)
        applicantProfileView.addSubviews(imageView, titleLabel, subTitleLabel)
    }
    
    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        applicantProfileView.snp.makeConstraints {
            $0.top.equalTo(self.snp.centerY).offset(-172)
            $0.horizontalEdges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(22)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        rejectView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(34)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        rejectReasonLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        rejectReasonTextBox.snp.makeConstraints {
            $0.top.equalTo(rejectReasonLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(92)
            $0.bottom.equalToSuperview()
        }
        
        rejectButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
    }
    
    override func setAddTarget() {
        navigationBar.leftButtonAction = { [weak self] in
            self?.onBackButtonDidTap?()
        }
        
        rejectButton.addTarget(self, action: #selector(rejectButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Method
    
    func configure(with output: HostRequestDeclineViewModel.DisplayData) {
        imageView.image = output.image
        titleLabel.text = output.title
        subTitleLabel.text = output.subTitle
        rejectButton.setTitle(output.buttonTitle, for: .normal)
    }
    
    // MARK: - Action
    
    @objc
    private func rejectButtonDidTap() {
        onRejectButtonDidTap?()
    }
}
