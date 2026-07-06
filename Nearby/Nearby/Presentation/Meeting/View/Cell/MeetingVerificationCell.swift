//
//  MeetingVerificationCell.swift
//  Nearby
//
//  Created by h2e on 7/6/26.
//

import UIKit

import SnapKit
import Then

final class MeetingVerificationCell: UICollectionViewCell {

    // MARK: - Properties

    static let identifier = "MeetingVerificationCell"

    var onVerifyButtonDidTap: (() -> Void)?

    // MARK: - UI Components

    private let contentStackView = UIStackView()

    private let profileView = MeetingProfileView()
    private let dividerView = UIView()

    private let verifyStackView = UIStackView()
    private let verifyTitleLabel = UILabel()
    private let verifySubtitleLabl = UILabel()
    private let verifyButton = NearbyButton(style: .gradient, title: "만남 인증하기")

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
        setUI()
        setLayout()
        setAddTarget()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setStyle() {
        contentView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 16
        }
        
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 16
        }
        
        dividerView.do {
            $0.backgroundColor = .grey10
        }
        
        verifyStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill
        }
        
        verifyTitleLabel.do {
            $0.text = "만남을 인증해주세요"
            $0.textColor = .grey80
            $0.font = NearbyFont.b2M16.font
            $0.textAlignment = .left
        }
        
        verifySubtitleLabl.do {
            $0.text = "동행자와 만나면 위치 인증으로 동행을 시작하세요"
            $0.textColor = .grey40
            $0.font = NearbyFont.b3M14.font
            $0.numberOfLines = 0
            $0.textAlignment = .left
        }
    }

    private func setUI() {
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubviews(profileView, dividerView, verifyStackView)
        verifyStackView.addArrangedSubviews(verifyTitleLabel, verifySubtitleLabl, verifyButton)
        verifyStackView.setCustomSpacing(16, after: verifySubtitleLabl)
    }

    private func setLayout() {
        contentStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        dividerView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        verifyButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
    }

    private func setAddTarget() {
        verifyButton.addTarget(self, action: #selector(verifyButtonDidTap), for: .touchUpInside)
    }

    func configure(type: MeetingVerificationCellType) {
        dividerView.isHidden = !type.showsVerifyView
        verifyStackView.isHidden = !type.showsVerifyView
    }

    // MARK: - Action

    @objc
    private func verifyButtonDidTap() {
        onVerifyButtonDidTap?()
        // TODO: - 만남 인증하기 API 연동
    }
}
