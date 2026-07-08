//
//  NearbyCheckBox.swift
//  Nearby
//
//  Created by 장지인 on 7/6/26.
//

import UIKit

import SnapKit
import Then

final class NearbyCheckBox: BaseView {

    // MARK: - UI Components

    private let checkButton = UIButton()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()

    // MARK: - Property

    var isChecked: Bool {
        didSet {
            checkButton.isSelected = isChecked
        }
    }

    // MARK: - Initializer

    init(text: String, isChecked: Bool = false) {
        self.isChecked = isChecked
        super.init(frame: .zero)

        checkButton.isSelected = isChecked
        titleLabel.text = text
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods

    override func setStyle() {
        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 10
        }

        checkButton.do {
            $0.setImage(.checkboxDefault, for: .normal)
            $0.setImage(.checkboxSelect, for: .selected)
        }

        titleLabel.do {
            $0.setFont(.b3M14, text: "", textColor: .grey30)
            $0.numberOfLines = 0
        }
    }

    override func setUI() {
        addSubview(stackView)
        stackView.addArrangedSubviews(checkButton, titleLabel)
    }

    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        checkButton.snp.makeConstraints {
            $0.size.equalTo(44)
        }
    }

    override func setAddTarget() {
        checkButton.addTarget(self, action: #selector(checkButtonDidTap), for: .touchUpInside)
    }

    // MARK: - Action

    @objc
    private func checkButtonDidTap() {
        isChecked.toggle()
    }
}
