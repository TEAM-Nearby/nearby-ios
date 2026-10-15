//
//  AgreementDetailView.swift
//  Nearby
//
//  Created by 신서연 on 10/16/26.
//

import UIKit

import SnapKit
import Then

final class AgreementDetailView: BaseView {

    // MARK: - UI Components

    let navigationBar = NearbyNavigationBar()

    private let scrollView = UIScrollView()

    private let contentView = UIView()

    private let contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .grey80
        $0.textAlignment = .left
    }

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .white

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        navigationBar.configure(leftItem: .back)
    }

    override func setUI() {
        addSubviews(navigationBar, scrollView)

        scrollView.addSubview(contentView)
        contentView.addSubview(contentLabel)
    }

    override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    func configure(title: String, content: String) {
        navigationBar.configure(leftItem: .back, centerItem: .title(title))
        contentLabel.text = content
    }
}
