//
//  PlaceSearchResultCell.swift
//  Nearby
//
//  Created by 장지인 on 7/13/26.
//

import UIKit

final class PlaceSearchResultCell: UITableViewCell {

    // MARK: - Properties

    static let identifier = String(describing: PlaceSearchResultCell.self)

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setStyle()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Methods

    func configure(with item: PlaceSearchResultItem) {
        var configuration = defaultContentConfiguration()
        configuration.text = item.name
        configuration.secondaryText = item.address
        configuration.secondaryTextProperties.numberOfLines = 1
        contentConfiguration = configuration
    }
}

// MARK: - Custom Methods

private extension PlaceSearchResultCell {
    func setStyle() {
        selectionStyle = .none
    }
}
