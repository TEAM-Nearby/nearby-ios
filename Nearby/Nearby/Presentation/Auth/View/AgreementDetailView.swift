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
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 0
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
        contentView.addSubview(contentStackView)
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

        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    func configure(title: String, content: String) {
        navigationBar.configure(leftItem: .back, centerItem: .title(title))

        contentStackView.arrangedSubviews.forEach {
            contentStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.minimumLineHeight = 19.6
        paragraphStyle.maximumLineHeight = 19.6

        let bodyAttributes: [NSAttributedString.Key: Any] = [.font: NearbyFont.b3M14.font, .foregroundColor: UIColor.grey50, .paragraphStyle: paragraphStyle]

        let titleAttributes: [NSAttributedString.Key: Any] = [.font: NearbyFont.b3Sb14.font, .foregroundColor: UIColor.grey50, .paragraphStyle: paragraphStyle]

        let attributedText = NSMutableAttributedString()
        let lines = content.components(separatedBy: "\n")

        func appendTextLabel() {
            guard attributedText.length > 0 else { return }

            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .left
            label.attributedText = NSAttributedString(attributedString: attributedText)

            contentStackView.addArrangedSubview(label)

            attributedText.deleteCharacters(in: NSRange(location: 0, length: attributedText.length))
        }

        var index = 0

        while index < lines.count {
            let line = lines[index]

            if line.trimmingCharacters(in: .whitespaces).hasPrefix("|") {
                var tableLines: [String] = []

                while index < lines.count, lines[index].trimmingCharacters(in: .whitespaces).hasPrefix("|") {
                    tableLines.append(lines[index])
                    index += 1
                }

                appendTextLabel()

                let tableView = makeMarkdownTable(lines: tableLines)
                contentStackView.addArrangedSubview(tableView)

                continue
            }

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

            index += 1
        }

        appendTextLabel()
    }
    
    private func makeMarkdownTable(lines: [String]) -> UIView {
        let tableStackView = UIStackView()
        tableStackView.axis = .vertical
        tableStackView.alignment = .fill
        tableStackView.distribution = .fill
        tableStackView.spacing = 0

        tableStackView.layer.borderWidth = 1
        tableStackView.layer.borderColor = UIColor.grey20.cgColor

        let rows = lines.compactMap { line -> [String]? in
            let cells = line
                .trimmingCharacters(in: .whitespaces)
                .trimmingCharacters(in: CharacterSet(charactersIn: "|"))
                .components(separatedBy: "|")
                .map { $0.trimmingCharacters(in: .whitespaces) }

            let isSeparator = cells.allSatisfy {
                !$0.isEmpty &&
                $0.allSatisfy { character in
                    character == "-" || character == ":"
                }
            }

            return isSeparator ? nil : cells
        }

        let columnCount = rows.map(\.count).max() ?? 0

        guard columnCount > 0 else { return tableStackView }

        for (rowIndex, cells) in rows.enumerated() {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.alignment = .fill
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 0

            for columnIndex in 0..<columnCount {
                let cellText = columnIndex < cells.count ? cells[columnIndex] : ""

                let cellContainer = UIView()

                let cellLabel = UILabel()
                cellLabel.numberOfLines = 0
                cellLabel.textAlignment = .left
                cellLabel.textColor = .grey50
                cellLabel.font = rowIndex == 0 ? NearbyFont.b3Sb14.font : NearbyFont.b3M14.font
                cellLabel.text = cellText

                cellContainer.addSubview(cellLabel)

                cellLabel.snp.makeConstraints {
                    $0.edges.equalToSuperview().inset(8)
                }

                if columnIndex < columnCount - 1 {
                    let divider = UIView()
                    divider.backgroundColor = .grey20

                    cellContainer.addSubview(divider)

                    divider.snp.makeConstraints {
                        $0.top.bottom.trailing.equalToSuperview()
                        $0.width.equalTo(1)
                    }
                }

                rowStackView.addArrangedSubview(cellContainer)
            }

            tableStackView.addArrangedSubview(rowStackView)

            if rowIndex < rows.count - 1 {
                let divider = UIView()
                divider.backgroundColor = .grey20

                divider.snp.makeConstraints {
                    $0.height.equalTo(1)
                }

                tableStackView.addArrangedSubview(divider)
            }
        }

        return tableStackView
    }

}
