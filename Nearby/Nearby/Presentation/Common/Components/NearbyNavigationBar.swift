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

    // MARK: - UI Components

    private let leftButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let logoLabel = UILabel()
    private let rightStackView = UIStackView()
    private let rightFirstButton = UIButton(type: .system)
    private let rightSecondButton = UIButton(type: .system)
    private let reportButton = UIButton(type: .system)

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setAddTarget()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        leftButton.do {
            $0.tintColor = .black
        }

        titleLabel.do {
            $0.font = NearbyFont.b1Sb18.font
            $0.textColor = .black
            $0.textAlignment = .center
        }

        logoLabel.do {
            $0.text = "Nearby 로고"
            $0.font = NearbyFont.b1M18.font
            $0.textColor = .black
        }

        rightStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
        }

        rightFirstButton.do {
            $0.tintColor = .black
        }

        rightSecondButton.do {
            $0.tintColor = .black
        }

        reportButton.do {
            $0.setTitle("신고", for: UIControl.State.normal)
            $0.setTitleColor(.systemRed, for: UIControl.State.normal)
            $0.titleLabel?.font = NearbyFont.b2Sb16.font
        }
    }

    override func setUI() {
        addSubviews(
            leftButton,
            titleLabel,
            logoLabel,
            rightStackView,
            reportButton
        )

        rightStackView.addArrangedSubviews(
            rightFirstButton,
            rightSecondButton
        )
    }

    override func setLayout() {
        snp.makeConstraints {
            $0.height.equalTo(64)
        }

        leftButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(44)
        }

        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        logoLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

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
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
    }

    func configure(
        leftItem: NearbyNavigationBarItem = .empty,
        centerItem: NearbyNavigationBarItem = .empty,
        rightItems: [NearbyNavigationBarItem] = []
    ) {
        configureLeftItem(leftItem)
        configureCenterItem(centerItem)
        configureRightItems(rightItems)
    }

    private func configureLeftItem(_ item: NearbyNavigationBarItem) {
        leftButton.isHidden = item == .empty
        leftButton.setImage(item.image, for: UIControl.State.normal)
    }

    private func configureCenterItem(_ item: NearbyNavigationBarItem) {
        titleLabel.isHidden = true
        logoLabel.isHidden = true

        switch item {
        case .title(let title):
            titleLabel.text = title
            titleLabel.isHidden = false

        case .logo:
            logoLabel.isHidden = false

        default:
            break
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

    private func setAddTarget() {
        leftButton.addTarget(
            self,
            action: #selector(leftButtonDidTap),
            for: UIControl.Event.touchUpInside
        )

        rightFirstButton.addTarget(
            self,
            action: #selector(rightFirstButtonDidTap),
            for: UIControl.Event.touchUpInside
        )

        rightSecondButton.addTarget(
            self,
            action: #selector(rightSecondButtonDidTap),
            for: UIControl.Event.touchUpInside
        )

    var leftButtonAction: (() -> Void)?
    var rightFirstButtonAction: (() -> Void)?
    var rightSecondButtonAction: (() -> Void)?
    var reportButtonAction: (() -> Void)?

        reportButton.addTarget(
            self,
            action: `#selector`(reportButtonDidTap),
            for: UIControl.Event.touchUpInside
        )

    `@objc`
    private func reportButtonDidTap() {
        reportButtonAction?()
    }
    }

    // MARK: - Action

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
}
