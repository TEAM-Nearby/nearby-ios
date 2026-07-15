//
//  CompanionRequestDeclineView.swift
//  Nearby
//
//  Created by h2e on 7/7/26.
//

import UIKit

import SnapKit
import Then

final class CompanionRequestDeclineView: BaseView {

    // MARK: - Properties

    var onBackButtonDidTap: (() -> Void)?
    var onSearchButtonDidTap: (() -> Void)?
    var onWriteButtonDidTap: (() -> Void)?

    // MARK: - UI Components
    
    private let navigationBar = NearbyNavigationBar()

    private let imageView = UIImageView()

    private let labelStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let writeButton = UIButton()
    
    private let searchButton = NearbyButton(style: .primary, title: "")

    // MARK: - Custom Methods

    override func setStyle() {
        imageView.do {
            $0.contentMode = .scaleAspectFit
        }

        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .center
        }

        titleLabel.do {
            $0.setFont(.h2M22, text: "", textColor: .black)
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }

        subtitleLabel.do {
            $0.setFont(.b2M16, text: "", textColor: .grey30)
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
        
        writeButton.do {
            $0.titleLabel?.font = NearbyFont.b2Sb16.font
            $0.setTitleColor(.grey80, for: .normal)
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .bgDefaultGrey
        }
        
        navigationBar.do {
            $0.configure(leftItem: .back, centerItem: .title("동행 신청"))
        }
    }

    override func setUI() {
        addSubviews(navigationBar, imageView, labelStackView, writeButton, searchButton)
        labelStackView.addArrangedSubviews(titleLabel, subtitleLabel)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.centerY).multipliedBy(0.92)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(185)
        }

        labelStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        searchButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
        
        writeButton.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(157)
            $0.height.equalTo(46)
        }
    }

    override func setAddTarget() {
        navigationBar.leftButtonAction = { [weak self] in
            self?.onBackButtonDidTap?()
        }
        writeButton.addTarget(self, action: #selector(writeButtonDidTap), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
    }

    // MARK: - Method

    func configure(with output: CompanionRequestDeclineViewModel.DisplayData) {
        imageView.image = output.image
        titleLabel.text = output.title
        subtitleLabel.text = output.subtitle
        writeButton.setTitle(output.writeButtonTitle, for: .normal)
        searchButton.setTitle(output.buttonTitle, for: .normal)
    }
    
    // MARK: - Actions
    
    @objc
    private func writeButtonDidTap() {
        onWriteButtonDidTap?()
    }

    @objc
    private func searchButtonDidTap() {
        onSearchButtonDidTap?()
    }
}
