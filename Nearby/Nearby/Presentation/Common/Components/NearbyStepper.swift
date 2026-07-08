//
//  NearbyStepper.swift
//  Nearby
//
//  Created by 장지인 on 7/6/26.
//

import UIKit

import SnapKit
import Then

final class NearbyStepper: BaseView {
    
    // MARK: - Properties
    
    private var count: Int
    private let minCount: Int
    private let maxCount: Int

    var countDidChange: ((Int) -> Void)?
    
    // MARK: - UI Components
    
    private let minusButton = UIButton()
    private let countLabel = UILabel()
    private let plusButton = UIButton()
    private let stackView = UIStackView()

    // MARK: - Initializer
    
    init(count: Int = 1, minCount: Int = 1, maxCount: Int = 7) {
        self.count = count
        self.minCount = minCount
        self.maxCount = maxCount
        super.init(frame: .zero)

        updateUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .grey5
        layer.cornerRadius = 16
        clipsToBounds = true
        
        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 14.5
            $0.distribution = .fill
        }
        
        minusButton.do {
            $0.setImage(.icMin.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        plusButton.do {
            $0.setImage(.plusIconHome.withRenderingMode(.alwaysTemplate), for: .normal)
        }

        countLabel.do {
            $0.font = NearbyFont.h3Sb20.font
            $0.textColor = .highlightTextPurple
            $0.textAlignment = .center
        }
    }

    override func setUI() {
        addSubview(stackView)
        stackView.addArrangedSubviews(minusButton, countLabel, plusButton)
    }

    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        [minusButton, plusButton].forEach {
            $0.snp.makeConstraints {
                $0.size.equalTo(48)
            }
        }
        
        countLabel.snp.makeConstraints {
            $0.width.equalTo(48)
            
        }
    }

    override func setAddTarget() {
        minusButton.addTarget(self, action: #selector(minusButtonDidTap), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Method

    private func updateUI() {
        countLabel.text = "\(count)"
        minusButton.isEnabled = count > minCount
        plusButton.isEnabled = count < maxCount
        minusButton.tintColor = minusButton.isEnabled ? .grey40 : .grey10
        plusButton.tintColor = plusButton.isEnabled ? .grey40 : .grey10
    }
    
    // MARK: - Actions

    @objc
    private func minusButtonDidTap() {
        guard count > minCount else { return }
        count -= 1
        updateUI()
        countDidChange?(count)
    }

    @objc
    private func plusButtonDidTap() {
        guard count < maxCount else { return }
        count += 1
        updateUI()
        countDidChange?(count)
    }
}
