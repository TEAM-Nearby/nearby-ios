//
//  CompanionRequestSentView.swift
//  Nearby
//
//  Created by h2e on 7/6/26.
//

import UIKit

import Lottie
import SnapKit
import Then

final class CompanionRequestSentView: BaseView {

    // MARK: - Properties

    var onBackButtonDidTap: (() -> Void)?
    var onSearchButtonDidTap: (() -> Void)?

    // MARK: - UI Components
    
    private let navigationBar = NearbyNavigationBar()

    private let animationView = LottieAnimationView(name: "RequestSent")

    private let labelStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let descriptionView = UIView()
    private let descriptionLabel = UILabel()

    private let searchButton = NearbyButton(style: .primary, title: "")

    // MARK: - Custom Methods

    override func setStyle() {
        animationView.do {
            $0.backgroundColor = .clear
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .loop
            $0.backgroundBehavior = .pauseAndRestore
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
        addSubviews(navigationBar, animationView, labelStackView, descriptionView, searchButton)
        labelStackView.addArrangedSubviews(titleLabel, subtitleLabel)
        descriptionView.addSubview(descriptionLabel)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        animationView.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.centerY).multipliedBy(0.97)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(500)
            $0.height.equalTo(animationView.snp.width)
        }

        labelStackView.snp.makeConstraints {
            $0.top.equalTo(animationView.snp.bottom).offset(-70)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        descriptionView.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        descriptionLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
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

    // MARK: - Methods

    func configure(with output: CompanionRequestSentViewModel.DisplayData) {
        titleLabel.text = output.title
        subtitleLabel.text = output.subtitle
        descriptionLabel.attributedText = output.description.withLineHeightMultiple(1.4, font: NearbyFont.b3M14.font, color: .grey40)
        searchButton.setTitle(output.buttonTitle, for: .normal)
    }
    
    func restartAnimation() {
        animationView.stop()
        animationView.currentProgress = 0
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: .loop)
    }
    
    // MARK: - Action

    @objc
    private func searchButtonDidTap() {
        onSearchButtonDidTap?()
    }
}
