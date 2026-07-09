//
//  NearbyNavigationBar.swift
//  Nearby
//
//  Created by 신서연 on 7/5/26.
//

import UIKit

import SnapKit
import Then

final class NearbyNavigationBar: BaseView {

    // MARK: - Properties

    var leftButtonAction: (() -> Void)?
    var rightFirstButtonAction: (() -> Void)?
    var rightSecondButtonAction: (() -> Void)?
    var reportButtonAction: (() -> Void)?
    var centerTitle: String?
    
    // MARK: - UI Components

    private let leftButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let logoImageView = UIImageView()
    private let rightStackView = UIStackView()
    private let rightFirstButton = UIButton(type: .system)
    private let rightSecondButton = UIButton(type: .system)
    private let reportButton = UIButton(type: .system)

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        leftButton.do {
            $0.tintColor = .grey80
        }

        titleLabel.do {
            $0.setFont(.b2Sb16, text: centerTitle, textColor: .grey80)
        }

        logoImageView.do {
            $0.image = .nearbyLogo.withRenderingMode(.alwaysOriginal)
            $0.contentMode = .scaleAspectFit
        }

        rightStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
        }

        rightFirstButton.do {
            $0.tintColor = .grey80
        }

        rightSecondButton.do {
            $0.tintColor = .grey80
        }

        reportButton.do {
            $0.setTitle("신고", for: UIControl.State.normal)
            $0.setTitleColor(.systemRed, for: UIControl.State.normal)
            $0.titleLabel?.font = NearbyFont.b2Sb16.font
            $0.setUnderline()
        }
    }

    override func setUI() {
        addSubviews(leftButton, titleLabel, logoImageView, rightStackView, reportButton)

        rightStackView.addArrangedSubviews(
            rightFirstButton, rightSecondButton
        )
    }

    override func setLayout() {
        snp.makeConstraints {
            $0.height.equalTo(48)
        }

        leftButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(44)
        }

        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        setLogoLayout(isCentered: false)

        rightStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }

        rightFirstButton.snp.makeConstraints {
            $0.size.equalTo(44)
        }

        rightSecondButton.snp.makeConstraints {
            $0.size.equalTo(44)
        }

        reportButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func setAddTarget() {
        leftButton.addTarget(self, action: #selector(leftButtonDidTap), for: .touchUpInside)
        rightFirstButton.addTarget(self, action: #selector(rightFirstButtonDidTap), for: .touchUpInside)
        rightSecondButton.addTarget(self, action: #selector(rightSecondButtonDidTap), for: .touchUpInside)
        reportButton.addTarget(self, action: #selector(reportButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Methods

    private func configureLeftItem(_ item: NearbyNavigationBarItem) {
        leftButton.isHidden = item == .empty || item == .logo
        
        if item == .logo {
            showLogo(isCentered: false)
            return
        }
        
        leftButton.setImage(item.image, for: UIControl.State.normal)
    }

    private func configureCenterItem(_ item: NearbyNavigationBarItem) {
        switch item {
        case .title(let title):
            titleLabel.text = title
            titleLabel.isHidden = false

        case .logo:
            showLogo(isCentered: true)

        default:
            break
        }
    }
    
    private func showLogo(isCentered: Bool) {
        logoImageView.isHidden = false
        setLogoLayout(isCentered: isCentered)
    }
    
    private func setLogoLayout(isCentered: Bool) {
        logoImageView.snp.remakeConstraints {
            if isCentered {
                $0.centerX.equalToSuperview()
            } else {
                $0.leading.equalToSuperview().inset(20)
            }
            
            $0.centerY.equalToSuperview()
            $0.width.equalTo(87)
            $0.height.equalTo(24)
        }
    }

    private func configureRightItems(_ items: [NearbyNavigationBarItem]) {
        rightStackView.isHidden = true
        reportButton.isHidden = true

        rightFirstButton.isHidden = true
        rightSecondButton.isHidden = true

        rightFirstButton.setImage(nil as UIImage?, for: UIControl.State.normal)
        rightSecondButton.setImage(nil as UIImage?, for: UIControl.State.normal)

        guard !items.isEmpty else { return }

        if items.count == 1, items.first == .report {
            reportButton.isHidden = false
            return
        }

        rightStackView.isHidden = false

        if items.indices.contains(0) {
            rightFirstButton.isHidden = false
            rightFirstButton.setImage(items[0].image, for: UIControl.State.normal)
        }

        if items.indices.contains(1) {
            rightSecondButton.isHidden = false
            rightSecondButton.setImage(items[1].image, for: UIControl.State.normal)
        }
    }
    
    func configure(
        leftItem: NearbyNavigationBarItem = .empty,
        centerItem: NearbyNavigationBarItem = .empty,
        rightItems: [NearbyNavigationBarItem] = []
    ) {
        titleLabel.isHidden = true
        logoImageView.isHidden = true
        
        configureLeftItem(leftItem)
        configureCenterItem(centerItem)
        configureRightItems(rightItems)
    }

    // MARK: - Actions

    @objc
    private func leftButtonDidTap() {
        leftButtonAction?()
    }

    @objc
    private func rightFirstButtonDidTap() {
        rightFirstButtonAction?()
    }

    @objc
    private func rightSecondButtonDidTap() {
        rightSecondButtonAction?()
    }
    
    @objc
    private func reportButtonDidTap() {
        reportButtonAction?()
    }
}
