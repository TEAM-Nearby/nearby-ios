//
//  UICollectionView+.swift
//  Nearby
//
//  Created by mandoo on 7/2/26.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: T.identifier)
    }

    func registerHeader<T: UICollectionReusableView>(_ viewClass: T.Type) {
        register(
            viewClass,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.identifier
        )
    }

    func registerFooter<T: UICollectionReusableView>(_ viewClass: T.Type) {
        register(
            viewClass,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: T.identifier
        )
    }

    func dequeueReusableCell<T: UICollectionViewCell>(
        _ cellClass: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: T.identifier,
            for: indexPath
        ) as? T else {
            fatalError("Failed to dequeue \(T.identifier)")
        }

        return cell
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        _ viewClass: T.Type,
        ofKind kind: String,
        for indexPath: IndexPath
    ) -> T {
        guard let view = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: T.identifier,
            for: indexPath
        ) as? T else {
            fatalError("Failed to dequeue \(T.identifier)")
        }

        return view
    }

    func dequeueReusableHeader<T: UICollectionReusableView>(
        _ viewClass: T.Type,
        for indexPath: IndexPath
    ) -> T {
        dequeueReusableSupplementaryView(
            viewClass,
            ofKind: UICollectionView.elementKindSectionHeader,
            for: indexPath
        )
    }

    func dequeueReusableFooter<T: UICollectionReusableView>(
        _ viewClass: T.Type,
        for indexPath: IndexPath
    ) -> T {
        dequeueReusableSupplementaryView(
            viewClass,
            ofKind: UICollectionView.elementKindSectionFooter,
            for: indexPath
        )
    }
}
