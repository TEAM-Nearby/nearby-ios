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
        $0.font = NearbyFont.b3M14.font
        $0.textColor = .grey50
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

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.minimumLineHeight = 19.6
        paragraphStyle.maximumLineHeight = 19.6

        let bodyAttributes: [NSAttributedString.Key: Any] = [.font: NearbyFont.b3M14.font, .foregroundColor: UIColor.grey50, .paragraphStyle: paragraphStyle]

        let titleAttributes: [NSAttributedString.Key: Any] = [.font: NearbyFont.b3Sb14.font, .foregroundColor: UIColor.grey50, .paragraphStyle: paragraphStyle]

        let attributedText = NSMutableAttributedString()
        let lines = content.components(separatedBy: "\n")

        for (index, line) in lines.enumerated() {
            if line.hasPrefix("#### ") {
                let title = String(line.dropFirst(5))
                attributedText.append(NSAttributedString(string: title, attributes: titleAttributes))
            } else if line.hasPrefix("**"), line.hasSuffix("**"), line.count >= 4 {
                let emphasizedText = String(line.dropFirst(2).dropLast(2))
                attributedText.append(NSAttributedString(string: emphasizedText, attributes: titleAttributes))
            } else {
                attributedText.append(NSAttributedString(string: line, attributes: bodyAttributes))
            }

            if index < lines.count - 1 {
                attributedText.append(NSAttributedString(string: "\n", attributes: bodyAttributes))
            }
        }

        contentLabel.attributedText = attributedText
    }

}
