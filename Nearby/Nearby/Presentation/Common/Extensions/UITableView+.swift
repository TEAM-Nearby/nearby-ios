//
//  UITableView+.swift
//  Nearby
//
//  Created by mandoo on 7/2/26.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: T.identifier)
    }

    func register<T: UITableViewHeaderFooterView>(_ viewClass: T.Type) {
        register(viewClass, forHeaderFooterViewReuseIdentifier: T.identifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(
        _ cellClass: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: T.identifier,
            for: indexPath
        ) as? T else {
            fatalError("Failed to dequeue \(T.identifier)")
        }

        return cell
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(
        _ viewClass: T.Type
    ) -> T {
        guard let view = dequeueReusableHeaderFooterView(
            withIdentifier: T.identifier
        ) as? T else {
            fatalError("Failed to dequeue \(T.identifier)")
        }

        return view
    }
}
