//
//  TermsListView.swift
//  Nearby
//
//  Created by 신서연 on 10/16/26.
//

import UIKit

import SnapKit
import Then

final class TermsListView: BaseView {
    
    // MARK: - Property

    var onTermsDidTap: ((AgreementDetailType) -> Void)?

    // MARK: - UI Components

    let navigationBar = NearbyNavigationBar()
    
    private let termsStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.distribution = .fill
    }
    
    private lazy var termsButtons: [UIButton] = {
        AgreementDetailType.settingsItems.map {
            makeTermsButton(title: $0.settingsTitle)
        }
    }()

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        navigationBar.configure(leftItem: .back, centerItem: .title("약관 확인하기"))
    }

    override func setUI() {
        addSubviews(navigationBar, termsStackView)

        termsButtons.forEach {
            termsStackView.addArrangedSubview($0)
        }
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        termsStackView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        termsButtons.forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(56)
            }
        }
    }
    
    override func setAddTarget() {
        for (index, button) in termsButtons.enumerated() {
            button.tag = index
            button.addTarget(self, action: #selector(termsButtonDidTap(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: - Methods

    private func makeTermsButton(title: String) -> UIButton {
        let button = UIButton(type: .system)

        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(title, attributes: AttributeContainer([.font: NearbyFont.b3M14.font, .foregroundColor: UIColor.grey80]))
        configuration.baseForegroundColor = .grey80
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        button.configuration = configuration
        button.contentHorizontalAlignment = .leading

        return button
    }
    
    @objc
    private func termsButtonDidTap(_ sender: UIButton) {
        let items = AgreementDetailType.settingsItems

        guard items.indices.contains(sender.tag) else { return }

        onTermsDidTap?(items[sender.tag])
    }
}
