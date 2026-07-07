//
//  CompanionRequestSentView.swift
//  Nearby
//
//  Created by h2e on 7/6/26.
//

import UIKit

import SnapKit
import Then

final class CompanionRequestSentView: BaseView {

    // MARK: - Properties

    var onBackButtonDidTap: (() -> Void)?
    var onSearchButtonDidTap: (() -> Void)?

    // MARK: - UI Components
    
    private let navigationBar = NearbyNavigationBar()

    private let imageView = UIImageView()

    private let labelStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let descriptionView = UIView()
    private let descriptionLabel = UILabel()

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
            $0.setFont(.h2M22, text: "", textColor: .grey80)
            $0.textAlignment = .center
        }

        subtitleLabel.do {
            $0.setFont(.b2M16, text: "", textColor: .grey30)
            $0.textAlignment = .center
        }

        descriptionView.do {
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .bgSurfaceGrey0
        }

        descriptionLabel.do {
            $0.setFont(.b3M14, text: "", textColor: .grey40)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byCharWrapping
        }
        
        navigationBar.do {
            $0.configure(leftItem: .back, centerItem: .title("동행 신청"))
        }
    }

    override func setUI() {
        addSubviews(navigationBar, imageView, labelStackView, descriptionView, searchButton)
        labelStackView.addArrangedSubviews(titleLabel, subtitleLabel)
        descriptionView.addSubview(descriptionLabel)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.centerY).offset(-40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(177)
        }

        labelStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        descriptionView.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        descriptionLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }

        searchButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
    }

    override func setAddTarget() {
        navigationBar.leftButtonAction = { [weak self] in
            self?.onBackButtonDidTap?()
        }
        searchButton.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
    }

    // MARK: - Method

    func configure(with output: CompanionRequestSentViewModel.DisplayData) {
        imageView.image = output.image
        titleLabel.text = output.title
        subtitleLabel.text = output.subtitle
        descriptionLabel.attributedText = output.description.withLineHeightMultiple(1.4, font: NearbyFont.b3M14.font, color: .grey40)
        searchButton.setTitle(output.buttonTitle, for: .normal)
    }
    
    // MARK: - Action

    @objc
    private func searchButtonDidTap() {
        onSearchButtonDidTap?()
    }
}
