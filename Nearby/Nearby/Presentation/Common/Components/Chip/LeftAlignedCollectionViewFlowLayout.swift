//
//  LeftAlignedCollectionViewFlowLayout.swift
//  Nearby
//
//  Created by 장지인 on 7/9/26.
//

import UIKit

final class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = (super.layoutAttributesForElements(in: rect) ?? []).compactMap {
            $0.copy() as? UICollectionViewLayoutAttributes
        }
        let cellAttributes = attributes
            .filter { $0.representedElementCategory == .cell }
            .sorted { $0.indexPath.item < $1.indexPath.item }
        var leftMargin: CGFloat = 0.0
        var maxY: CGFloat = -1.0

        cellAttributes.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = 0.0
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}
