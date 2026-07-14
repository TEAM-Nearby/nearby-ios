//
//  AlarmRequestTableViewCell.swift
//  Nearby
//
//  Created by 신서연 on 7/11/26.
//

import UIKit

import SnapKit
import Then

final class AlarmRequestTableViewCell: UITableViewCell {

    // MARK: - Properties

    static let identifier = String(describing: AlarmRequestTableViewCell.self)

    var onActionButtonDidTap: (() -> Void)?

    private var statusIconWidthConstraint: Constraint?
    private var statusIconHeightConstraint: Constraint?

    private var actionButtonHeightConstraint: Constraint?
    private var actionButtonTopConstraint: Constraint?
    private var actionButtonBottomConstraint: Constraint?
    private var informationBottomConstraint: Constraint?

    // MARK: - UI Components

    private let cardView = UIView()

    private let profileImageView = GradientCircleView(diameter: 50)

    private let titleStackView = UIStackView()
    private let statusIconImageView = UIImageView()
    private let titleLabel = UILabel()

    private let informationLabel = UILabel()

    private let actionButton = UIButton(type: .system)

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setStyle()
        setUI()
        setLayout()
        setAddTarget()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        onActionButtonDidTap = nil

        profileImageView.configure(image: .imgProfileDefault)

        statusIconImageView.image = nil
        statusIconImageView.isHidden = false
        statusIconImageView.tintColor = nil

        statusIconWidthConstraint?.update(offset: 20)

        statusIconHeightConstraint?.update(offset: 20)

        titleLabel.text = nil
        informationLabel.text = nil

        actionButton.setTitle(nil, for: .normal)

        actionButton.isHidden = false
        actionButton.isUserInteractionEnabled = true

        contentView.alpha = 1.0
    }

    // MARK: - Method

    func configure(with item: AlarmRequestItem) {
        configureProfileImage(with: item.profileImageURL)

        titleLabel.text = item.displayType.title
        informationLabel.text = [item.nickname, item.dateText].joined(separator: " · ")

        configureActionButton(with: item.displayType)
        configureIcon(with: item.displayType)
        configureAppearance(with: item.displayType, isRead: item.isRead)
    }

    // MARK: - Action

    @objc
    private func actionButtonDidTap() {
        onActionButtonDidTap?()
    }
}

// MARK: - Custom Methods

private extension AlarmRequestTableViewCell {

    func setStyle() {
        selectionStyle = .none

        backgroundColor = .clear
        contentView.backgroundColor = .clear

        cardView.do {
            $0.layer.cornerRadius = 16
            $0.layer.borderWidth = 1
            $0.clipsToBounds = true
        }

        titleStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 6
        }

        statusIconImageView.do {
            $0.contentMode = .scaleAspectFit
        }

        titleLabel.do {
            $0.font = NearbyFont.b2M16.font
            $0.textColor = .grey80
            $0.numberOfLines = 1
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }

        informationLabel.do {
            $0.font = NearbyFont.b3M14.font
            $0.textColor = .grey60
            $0.numberOfLines = 1
        }

        actionButton.do {
            $0.titleLabel?.font = NearbyFont.b2M16.font
            $0.setTitleColor(.grey80, for: .normal)
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
        }
    }

    func setUI() {
        contentView.addSubview(cardView)

        cardView.addSubviews(profileImageView, titleStackView, informationLabel, actionButton)
        titleStackView.addArrangedSubviews(statusIconImageView, titleLabel)
    }

    func setLayout() {
        cardView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.horizontalEdges.equalToSuperview()
        }

        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(50)
        }

        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(21)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
            $0.height.greaterThanOrEqualTo(24)
        }

        statusIconImageView.snp.makeConstraints {
            statusIconWidthConstraint = $0.width.equalTo(20).constraint
            statusIconHeightConstraint = $0.height.equalTo(20).constraint
        }

        informationLabel.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(6)
            $0.leading.equalTo(titleStackView)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)

            informationBottomConstraint = $0.bottom.equalToSuperview().inset(20).constraint
        }

        actionButton.snp.makeConstraints {
            actionButtonTopConstraint = $0.top.equalTo(profileImageView.snp.bottom).offset(12).constraint
            $0.horizontalEdges.equalToSuperview().inset(20)
            actionButtonHeightConstraint = $0.height.equalTo(44).constraint
            actionButtonBottomConstraint = $0.bottom.equalToSuperview().inset(20).constraint
        }
        
        informationBottomConstraint?.deactivate()
    }

    func setAddTarget() {
        actionButton.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
    }

    func configureProfileImage(with url: URL?) {
        profileImageView.configure(imageUrl: url?.absoluteString)
    }

    func configureActionButton(with displayType: AlarmRequestDisplayType) {
        guard let buttonTitle = displayType.buttonTitle else {
            actionButton.setTitle(nil, for: .normal)
            actionButton.isHidden = true
            actionButton.isUserInteractionEnabled = false

            actionButtonTopConstraint?.deactivate()
            actionButtonHeightConstraint?.deactivate()
            actionButtonBottomConstraint?.deactivate()
            informationBottomConstraint?.activate()

            return
        }

        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.isHidden = false
        actionButton.isUserInteractionEnabled = true

        informationBottomConstraint?.deactivate()
        actionButtonTopConstraint?.activate()
        actionButtonHeightConstraint?.activate()
        actionButtonBottomConstraint?.activate()
    }

    func configureIcon(with displayType: AlarmRequestDisplayType) {
        guard let icon = displayType.icon else {
            statusIconImageView.image = nil
            statusIconImageView.isHidden = true

            statusIconWidthConstraint?.update(offset: 0)
            statusIconHeightConstraint?.update(offset: 0)

            return
        }

        statusIconImageView.isHidden = false
        statusIconWidthConstraint?.update(offset: displayType.iconSize.width)
        statusIconHeightConstraint?.update(offset: displayType.iconSize.height)

        if let tintColor =
            displayType.iconTintColor {
            statusIconImageView.image = icon.withRenderingMode(.alwaysTemplate)

            statusIconImageView.tintColor = tintColor
        } else {
            statusIconImageView.image = icon.withRenderingMode(.alwaysOriginal)
            statusIconImageView.tintColor = nil
        }
    }

    func configureAppearance(
        with displayType: AlarmRequestDisplayType,
        isRead: Bool
    ) {
        if isRead {
            configureReadAppearance()
            return
        }

        if displayType.isHighlighted {
            configureHighlightedAppearance()
        } else {
            configureDefaultAppearance()
        }
    }

    func configureHighlightedAppearance() {
        cardView.backgroundColor = UIColor.primary50.withAlphaComponent(0.05)
        cardView.layer.borderColor = UIColor.primary50.withAlphaComponent(0.25).cgColor
        actionButton.backgroundColor = UIColor.primary50.withAlphaComponent(0.18)
        actionButton.setTitleColor(.grey80, for: .normal)

        contentView.alpha = 1.0
    }

    func configureDefaultAppearance() {
        cardView.backgroundColor = .grey5
        cardView.layer.borderColor = UIColor.clear.cgColor
        actionButton.backgroundColor = .grey10
        actionButton.setTitleColor(.grey80, for: .normal)

        contentView.alpha = 1.0
    }
    
    func configureReadAppearance() {
        cardView.backgroundColor = .grey5
        cardView.layer.borderColor = UIColor.clear.cgColor

        actionButton.backgroundColor = .grey10
        actionButton.setTitleColor(.grey80, for: .normal)

        if statusIconImageView.image?.renderingMode == .alwaysTemplate {
            statusIconImageView.tintColor = .grey40
        }

        contentView.alpha = 1.0
    }
}
