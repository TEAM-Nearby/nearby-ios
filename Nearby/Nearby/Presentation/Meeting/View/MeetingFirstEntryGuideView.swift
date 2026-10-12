//
//  MeetingFirstEntryGuideView.swift
//  Nearby
//
//  Created by h2e on 10/12/26.
//

import UIKit

import SnapKit
import Then

final class MeetingFirstEntryGuideView: BaseView {

    // MARK: - UI Components

    private let backgroundButton = UIButton()
    private let closeButton = UIButton(type: .system)
    private let progressArrowImageView = UIImageView()
    private let progressGuideLabel = UILabel()
    private let sampleCardStackView = UIStackView()
    private let progressSampleCell = MeetingVerificationCell(frame: .zero)
    private let verificationSampleCell = MeetingVerificationCell(frame: .zero)
    private let verificationArrowImageView = UIImageView()
    private let verificationGuideLabel = UILabel()
    private let verificationBulletLabel = UILabel()
    private let verificationDescriptionLabel = UILabel()

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = UIColor.black.withAlphaComponent(0.75)

        closeButton.do {
            $0.setImage(.cancelIcon.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .white
        }

        progressArrowImageView.do {
            $0.image = UIImage(named: "akar-icons_arrow-back")
            $0.contentMode = .scaleAspectFit
            $0.transform = CGAffineTransform(scaleX: 1, y: -1)
        }

        progressGuideLabel.do {
            $0.setFont(.b3Sb14, text: "클릭하면 동행 진행 상황을 볼 수 있어요.", textColor: .white)
            $0.setHighlight(target: "동행 진행 상황", color: .primary30)
        }

        sampleCardStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
            $0.isUserInteractionEnabled = false
        }

        progressSampleCell.configure(with: .sample, cellType: .notYet)
        verificationSampleCell.configure(with: .sample, cellType: .verifiable)

        verificationArrowImageView.do {
            $0.image = UIImage(named: "akar-icons_arrow-back")
            $0.contentMode = .scaleAspectFit
        }

        verificationGuideLabel.do {
            $0.setFont(.b2Sb16, text: "만남 시간 1시간 전부터\n만남 인증하기 버튼이 활성화돼요!", textColor: .white)
            $0.setHighlight(target: "만남 인증하기 버튼", color: .primary30)
            $0.numberOfLines = 0
        }

        verificationBulletLabel.do {
            $0.setFont(.b3M14, text: "*", textColor: .grey10)
        }

        verificationDescriptionLabel.do {
            $0.setFont(.b3M14, text: "만남 장소에 도착해서\n만남 인증하기 버튼을 눌러주세요", textColor: .grey10)
            $0.numberOfLines = 0
        }
    }

    override func setUI() {
        addSubviews(
            backgroundButton,
            closeButton,
            progressArrowImageView,
            progressGuideLabel,
            sampleCardStackView,
            verificationArrowImageView,
            verificationGuideLabel,
            verificationBulletLabel,
            verificationDescriptionLabel
        )
        sampleCardStackView.addArrangedSubviews(progressSampleCell, verificationSampleCell)
    }

    override func setLayout() {
        backgroundButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        closeButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(30)
        }

        sampleCardStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(126)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        [progressSampleCell, verificationSampleCell].forEach { cell in
            cell.contentView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }

        progressArrowImageView.snp.makeConstraints {
            $0.bottom.equalTo(sampleCardStackView.snp.top).offset(-18)
            $0.leading.equalToSuperview().inset(40)
            $0.size.equalTo(24)
        }

        progressGuideLabel.snp.makeConstraints {
            $0.centerY.equalTo(progressArrowImageView)
            $0.leading.equalTo(progressArrowImageView.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
        }

        verificationArrowImageView.snp.makeConstraints {
            $0.top.equalTo(sampleCardStackView.snp.bottom).offset(18)
            $0.leading.equalToSuperview().inset(40)
            $0.size.equalTo(24)
        }

        verificationGuideLabel.snp.makeConstraints {
            $0.top.equalTo(sampleCardStackView.snp.bottom).offset(21)
            $0.leading.equalTo(verificationArrowImageView.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
        }

        verificationBulletLabel.snp.makeConstraints {
            $0.top.equalTo(verificationGuideLabel.snp.bottom).offset(8)
            $0.leading.equalTo(verificationGuideLabel)
        }

        verificationDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(verificationBulletLabel)
            $0.leading.equalTo(verificationBulletLabel.snp.trailing).offset(4)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
        }
    }

    override func setAddTarget() {
        backgroundButton.addTarget(self, action: #selector(dismissGuide), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(dismissGuide), for: .touchUpInside)
    }

    // MARK: - Action

    @objc
    private func dismissGuide() {
        removeFromSuperview()
    }
}
